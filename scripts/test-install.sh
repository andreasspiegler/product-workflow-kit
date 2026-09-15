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
  rg -Fq -- "$2" "$1" || fail "expected $1 to contain: $2"
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

printf 'Installer smoke test passed.\n'
