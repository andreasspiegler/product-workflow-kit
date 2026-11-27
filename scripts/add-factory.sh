#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  scripts/add-factory.sh --target <product-directory> [--stack <python|node|generic>]

Add factory mode to a product: issues labelled `factory:ready` are specified,
built, verified, reviewed, and merged by a GitHub Actions workflow without a
human, up to the autonomy ceiling recorded in PRODUCT.md. Works for new
products (called by install.sh --mode factory) and for existing ones. Writes
only project-local files, never overwrites, and changes no remote settings.

Installs:
  .github/workflows/factory.yml   the factory workflow (Claude Code GitHub Action)
  .github/workflows/factory-round.yml  one build → verify → review round
  .factory/setup.sh               toolchain and dependency setup for checks
  .factory/check.sh               all tests, including tests/acceptance/ and the
                                  hidden tests the factory adds under tests/holdout/
  .factory/context.sh             writes the trusted issue context for the agents
  .factory/README.md              one-time setup checklist and limits
  .claude/skills/factory-run/     the headless stage instructions

Requires a Git repository and agent isolation at level agent or container
(.claude/settings.json), because the factory runs Claude Code unattended.

Options:
  --stack <python|node|generic>   Fills setup.sh and check.sh. Default: python
                                  if pyproject.toml exists, node if
                                  package.json exists, otherwise generic
                                  (both scripts then fail until configured).
  --help                          Show this help.
EOF
}

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

KIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
TEMPLATES="$KIT_ROOT/templates/factory"
UV_VERSION="0.13.7"

TARGET=""
STACK=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target) [[ $# -ge 2 ]] || fail "--target requires a directory"; TARGET="$2"; shift 2 ;;
    --stack) [[ $# -ge 2 ]] || fail "--stack requires a value"; STACK="$2"; shift 2 ;;
    --help|-h) usage; exit 0 ;;
    *) fail "unknown option: $1" ;;
  esac
done

[[ -n "$TARGET" ]] || fail "--target is required"
[[ -d "$TARGET" ]] || fail "target directory does not exist: $TARGET"
TARGET="$(cd "$TARGET" && pwd -P)"
[[ "$TARGET" != "$KIT_ROOT" ]] || fail "target must be a product directory, not the kit checkout"
[[ -d "$TARGET/.git" ]] || fail "factory mode needs a Git repository in the target"
[[ -f "$TARGET/.claude/settings.json" ]] || fail "factory mode needs agent isolation first: scripts/add-sandbox.sh --level agent (or container)"

if [[ -z "$STACK" ]]; then
  if [[ -f "$TARGET/pyproject.toml" ]]; then STACK=python
  elif [[ -f "$TARGET/package.json" ]]; then STACK=node
  else STACK=generic
  fi
fi
case "$STACK" in python|node|generic) ;; *) fail "unsupported stack: $STACK" ;; esac

for relative_path in .github/workflows/factory.yml .github/workflows/factory-round.yml .factory .claude/skills/factory-run; do
  [[ ! -e "$TARGET/$relative_path" ]] || fail "refusing to overwrite existing $relative_path"
done

case "$STACK" in
  python)
    SETUP_BODY="command -v uv >/dev/null || pipx install \"uv==${UV_VERSION}\"
uv sync"
    CHECK_BODY="uv run pytest"
    ;;
  node)
    if [[ -f "$TARGET/package-lock.json" ]]; then SETUP_BODY="npm ci"; else SETUP_BODY="npm install"; fi
    CHECK_BODY="npm test"
    ;;
  generic)
    SETUP_BODY="echo 'Configure .factory/setup.sh: install the toolchain and dependencies.' >&2
exit 1"
    CHECK_BODY="echo 'Configure .factory/check.sh: run every test, including tests/acceptance/ and tests/holdout/.' >&2
exit 1"
    ;;
esac

write_script() {
  local path="$1" purpose="$2" body="$3"
  {
    printf '#!/usr/bin/env bash\n'
    printf '# %s\n' "$purpose"
    printf '# Protected path: the factory must not change this file. Edit it by hand.\n'
    printf 'set -euo pipefail\n'
    printf 'cd "$(dirname "${BASH_SOURCE[0]}")/.."\n\n'
    printf '%s\n' "$body"
  } > "$path"
  chmod +x "$path"
}

mkdir -p "$TARGET/.github/workflows" "$TARGET/.factory" "$TARGET/.claude/skills"
cp "$TEMPLATES/factory.yml" "$TARGET/.github/workflows/factory.yml"
cp "$TEMPLATES/factory-round.yml" "$TARGET/.github/workflows/factory-round.yml"
cp "$TEMPLATES/README.md" "$TARGET/.factory/README.md"
cp "$TEMPLATES/context.sh" "$TARGET/.factory/context.sh"
chmod +x "$TARGET/.factory/context.sh"
write_script "$TARGET/.factory/setup.sh" \
  "Installs the toolchain and dependencies. Runs outside the agent sandbox, before each stage and in verify." \
  "$SETUP_BODY"
write_script "$TARGET/.factory/check.sh" \
  "Runs every test, including tests/acceptance/ and tests/holdout/. Must exit non-zero on any failure." \
  "$CHECK_BODY"
cp -R "$KIT_ROOT/skills/factory-run" "$TARGET/.claude/skills/factory-run"

printf 'Installed factory mode (%s stack): .github/workflows/factory*.yml, .factory/, .claude/skills/factory-run/\n' "$STACK"
[[ "$STACK" != generic ]] || printf 'Next: configure .factory/setup.sh and .factory/check.sh; both fail until you do.\n'
printf 'Next: complete the one-time setup in .factory/README.md (GitHub App, secret, labels, staging).\n'
printf 'Record under "Operating mode" in PRODUCT.md (start slow: pr-only until the factory earns trust):\n\n'
printf '  mode: factory\n  autonomy_ceiling: micro\n  merge: pr-only\n  deploy: human\n\n'
printf 'No remote settings, secrets, labels, or branch protection were changed.\n'
