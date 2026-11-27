#!/usr/bin/env bash

set -euo pipefail

KIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
TEMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/product-workflow-kit-test.XXXXXX")"
TARGET="$TEMP_ROOT/product"

cleanup() {
  rm -rf "$TEMP_ROOT"
}
trap cleanup EXIT

fail() {
  printf 'Smoke test failed: %s\n' "$*" >&2
  exit 1
}

assert_file() {
  [[ -f "$1" ]] || fail "missing file: $1"
}

assert_directory() {
  [[ -d "$1" ]] || fail "missing directory: $1"
}

assert_contains() {
  grep -Fq -- "$2" "$1" || fail "expected $1 to contain: $2"
}

# Every relative Markdown link in installed files must resolve inside the product.
assert_relative_links_resolve() {
  local root="$1"
  local file link target
  while IFS= read -r -d '' file; do
    while IFS= read -r link; do
      link="${link%%#*}"
      [[ -n "$link" ]] || continue
      case "$link" in
        http://*|https://*|mailto:*) continue ;;
      esac
      target="$(dirname "$file")/$link"
      [[ -e "$target" ]] || fail "broken relative link in ${file#"$root"/}: $link"
    done < <(grep -oE '\]\([^)]+\)' "$file" | sed -E 's/^\]\((.*)\)$/\1/')
  done < <(find "$root" -type f -name '*.md' -print0)
}

mkdir -p "$TARGET"
"$KIT_ROOT/scripts/install.sh" \
  --target "$TARGET" \
  --runtime claude \
  --runtime codex \
  --runtime opencode \
  --agent tech-lead \
  --kit-version smoke-test-version \
  > "$TEMP_ROOT/install-output.txt"

for path in AGENTS.md CLAUDE.md PRODUCT.md DESIGN.md docs/decisions/README.md docs/decisions/TEMPLATE.md; do
  assert_file "$TARGET/$path"
done
assert_contains "$TARGET/PRODUCT.md" 'version: "smoke-test-version"'
assert_contains "$TEMP_ROOT/install-output.txt" 'workflow files are internal'
assert_contains "$TARGET/AGENTS.md" 'Workflow files are internal and never ship with the product'
assert_relative_links_resolve "$TARGET"
assert_contains "$TARGET/.claude/skills/feature/README.md" 'github.com/andreasspiegler/product-workflow-kit/blob/'

for runtime_dir in .claude/skills .agents/skills .opencode/skills; do
  for skill in kickoff feature requirements-quality product-design quality-release; do
    assert_directory "$TARGET/$runtime_dir/$skill"
    assert_file "$TARGET/$runtime_dir/$skill/SKILL.md"
  done
done

assert_file "$TARGET/.claude/agents/tech-lead.md"
assert_file "$TARGET/.opencode/agents/tech-lead.md"
[[ ! -e "$TARGET/.agents/agents/tech-lead.md" ]] || fail 'Codex must not receive an agent brief directory'

if "$KIT_ROOT/scripts/install.sh" --target "$TARGET" --runtime claude --kit-version smoke-test-version >/dev/null 2>&1; then
  fail 'installer accepted an overwrite of existing product context'
fi

CODEX_TARGET="$TEMP_ROOT/codex-only"
mkdir -p "$CODEX_TARGET"
"$KIT_ROOT/scripts/install.sh" \
  --target "$CODEX_TARGET" \
  --runtime codex \
  --kit-version smoke-test-version \
  > "$TEMP_ROOT/codex-install-output.txt"
assert_file "$CODEX_TARGET/AGENTS.md"
[[ ! -e "$CODEX_TARGET/CLAUDE.md" ]] || fail 'Codex-only install must not create CLAUDE.md'

assert_not_contains() {
  ! grep -Fq -- "$2" "$1" || fail "expected $1 not to contain: $2"
}

assert_valid_json() {
  python3 -c 'import json, sys; json.load(open(sys.argv[1]))' "$1" || fail "invalid JSON: $1"
}

# Without --sandbox the decision is left to kickoff.
assert_contains "$TARGET/PRODUCT.md" 'Not decided yet'
assert_not_contains "$TARGET/PRODUCT.md" '{{AGENT_ISOLATION}}'
[[ ! -e "$TARGET/.claude/settings.json" ]] || fail 'install without --sandbox must not write .claude/settings.json'

# Agent level at install time.
AGENT_TARGET="$TEMP_ROOT/agent-sandbox"
mkdir -p "$AGENT_TARGET"
"$KIT_ROOT/scripts/install.sh" --target "$AGENT_TARGET" --runtime claude --sandbox agent \
  --kit-version smoke-test-version > /dev/null
assert_valid_json "$AGENT_TARGET/.claude/settings.json"
assert_contains "$AGENT_TARGET/.claude/settings.json" '"allowUnsandboxedCommands": false'
assert_contains "$AGENT_TARGET/PRODUCT.md" 'Level: agent.'
[[ ! -e "$AGENT_TARGET/.devcontainer" ]] || fail 'agent level must not install a Dev Container'
if "$KIT_ROOT/scripts/add-sandbox.sh" --target "$AGENT_TARGET" --level agent >/dev/null 2>&1; then
  fail 'add-sandbox accepted an overwrite of .claude/settings.json'
fi

# The agent level configures Claude Code and must refuse a Codex-only install.
CODEX_SANDBOX_TARGET="$TEMP_ROOT/codex-sandbox"
mkdir -p "$CODEX_SANDBOX_TARGET"
if "$KIT_ROOT/scripts/install.sh" --target "$CODEX_SANDBOX_TARGET" --runtime codex --sandbox agent \
  --kit-version smoke-test-version >/dev/null 2>&1; then
  fail 'install accepted --sandbox agent without the claude runtime'
fi
[[ ! -e "$CODEX_SANDBOX_TARGET/AGENTS.md" ]] || fail 'failed sandbox precondition must not leave partial files'

# Container level for an existing Node product.
CONTAINER_TARGET="$TEMP_ROOT/container-sandbox"
mkdir -p "$CONTAINER_TARGET/.git"
printf '{}\n' > "$CONTAINER_TARGET/package.json"
"$KIT_ROOT/scripts/add-sandbox.sh" --target "$CONTAINER_TARGET" --level container --app-port 4173 > /dev/null
for path in devcontainer.json Dockerfile init-firewall.sh dev README.md expose.sh; do
  assert_file "$CONTAINER_TARGET/.devcontainer/$path"
  assert_not_contains "$CONTAINER_TARGET/.devcontainer/$path" '{{'
done
assert_valid_json "$CONTAINER_TARGET/.claude/settings.json"
assert_contains "$CONTAINER_TARGET/.devcontainer/Dockerfile" 'FROM node:22-bookworm-slim'
assert_contains "$CONTAINER_TARGET/.devcontainer/devcontainer.json" 'container-sandbox-node-modules'
assert_contains "$CONTAINER_TARGET/.devcontainer/devcontainer.json" '"127.0.0.1:4173:9999"'
assert_contains "$CONTAINER_TARGET/.devcontainer/init-firewall.sh" 'registry.npmjs.org'
[[ -x "$CONTAINER_TARGET/.devcontainer/dev" ]] || fail 'dev launcher must be executable'
bash -n "$CONTAINER_TARGET/.devcontainer/init-firewall.sh" || fail 'firewall script has a syntax error'
if "$KIT_ROOT/scripts/add-sandbox.sh" --target "$TEMP_ROOT/agent-sandbox" --level container >/dev/null 2>&1; then
  fail 'add-sandbox accepted --level container without a Git repository'
fi

# Without --mode the operating mode is left to kickoff and nothing factory-related is installed.
assert_not_contains "$TARGET/PRODUCT.md" '{{OPERATING_MODE}}'
assert_contains "$TARGET/PRODUCT.md" '## Operating mode'
[[ ! -e "$TARGET/.github" && ! -e "$TARGET/.factory" ]] || fail 'install without --mode must not install factory files'

if "$KIT_ROOT/scripts/install.sh" --target "$TEMP_ROOT/codex-only" --runtime codex --stack node \
  --kit-version smoke-test-version >/dev/null 2>&1; then
  fail 'install accepted --stack without --sandbox container or --mode factory'
fi

# Factory mode at install time for a Node product.
FACTORY_TARGET="$TEMP_ROOT/factory"
mkdir -p "$FACTORY_TARGET/.git"
printf '{}\n' > "$FACTORY_TARGET/package.json"
printf '{}\n' > "$FACTORY_TARGET/package-lock.json"
"$KIT_ROOT/scripts/install.sh" --target "$FACTORY_TARGET" --runtime claude --sandbox agent --mode factory \
  --kit-version smoke-test-version > /dev/null
for path in .github/workflows/factory.yml .factory/README.md .factory/setup.sh .factory/check.sh .claude/skills/factory-run/SKILL.md; do
  assert_file "$FACTORY_TARGET/$path"
done
[[ -x "$FACTORY_TARGET/.factory/setup.sh" && -x "$FACTORY_TARGET/.factory/check.sh" ]] || fail 'factory scripts must be executable'
assert_contains "$FACTORY_TARGET/.factory/setup.sh" 'npm ci'
assert_contains "$FACTORY_TARGET/.factory/check.sh" 'npm test'
bash -n "$FACTORY_TARGET/.factory/setup.sh" || fail 'setup.sh has a syntax error'
bash -n "$FACTORY_TARGET/.factory/check.sh" || fail 'check.sh has a syntax error'
assert_contains "$FACTORY_TARGET/.github/workflows/factory.yml" 'anthropics/claude-code-action@'
assert_relative_links_resolve "$FACTORY_TARGET"

# The workflow parses these PRODUCT.md values with the same sed expressions.
read_mode_value() {
  sed -nE "s/^$1: *([a-z-]+).*/\\1/p" "$FACTORY_TARGET/PRODUCT.md" | head -n1
}
[[ "$(read_mode_value mode)" == factory ]] || fail 'workflow cannot read mode from PRODUCT.md'
[[ "$(read_mode_value autonomy_ceiling)" == micro ]] || fail 'workflow cannot read autonomy_ceiling from PRODUCT.md'
[[ "$(read_mode_value merge)" == auto ]] || fail 'workflow cannot read merge from PRODUCT.md'
[[ "$(read_mode_value deploy)" == human ]] || fail 'workflow cannot read deploy from PRODUCT.md'
for workflow_key in mode autonomy_ceiling merge deploy; do
  [[ "$(grep -Ec "^$workflow_key:" "$FACTORY_TARGET/PRODUCT.md")" == 1 ]] || fail "PRODUCT.md must contain exactly one $workflow_key line"
done

if "$KIT_ROOT/scripts/add-factory.sh" --target "$FACTORY_TARGET" >/dev/null 2>&1; then
  fail 'add-factory accepted an overwrite of existing factory files'
fi

# Factory mode needs agent isolation and the Claude Code runtime, and fails before writing.
FACTORY_NO_SANDBOX="$TEMP_ROOT/factory-no-sandbox"
mkdir -p "$FACTORY_NO_SANDBOX/.git"
if "$KIT_ROOT/scripts/install.sh" --target "$FACTORY_NO_SANDBOX" --runtime claude --mode factory \
  --kit-version smoke-test-version >/dev/null 2>&1; then
  fail 'install accepted --mode factory without agent isolation'
fi
[[ ! -e "$FACTORY_NO_SANDBOX/AGENTS.md" ]] || fail 'failed factory precondition must not leave partial files'
if "$KIT_ROOT/scripts/install.sh" --target "$FACTORY_NO_SANDBOX" --runtime codex --sandbox agent --mode factory \
  --kit-version smoke-test-version >/dev/null 2>&1; then
  fail 'install accepted --mode factory without the claude runtime'
fi
if "$KIT_ROOT/scripts/add-factory.sh" --target "$FACTORY_NO_SANDBOX" >/dev/null 2>&1; then
  fail 'add-factory accepted a product without .claude/settings.json'
fi

# A generic stack gets check scripts that fail until configured.
GENERIC_TARGET="$TEMP_ROOT/factory-generic"
mkdir -p "$GENERIC_TARGET/.git"
"$KIT_ROOT/scripts/add-sandbox.sh" --target "$GENERIC_TARGET" --level agent > /dev/null
"$KIT_ROOT/scripts/add-factory.sh" --target "$GENERIC_TARGET" > /dev/null
if "$GENERIC_TARGET/.factory/check.sh" >/dev/null 2>&1; then
  fail 'unconfigured generic check.sh must fail'
fi

printf 'Installer smoke test passed.\n'
