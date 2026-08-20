#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  scripts/install.sh --target <product-directory> --runtime <claude|codex|opencode> [options]

Install the Product Workflow Kit into an existing product directory. The script
only writes project-local files. It never installs global skills, hooks,
plugins, permissions, or connectors.

Required:
  --target <directory>       Existing product directory to receive the kit.
  --runtime <name>           Runtime to configure; repeat for multiple runtimes.

Options:
  --skill <name>             Install one selected skill; repeat to choose several.
                              Defaults to kickoff, feature, requirements-quality,
                              product-design, and quality-release.
  --agent <name>             Install one optional specialist agent brief from
                              agents/; repeat to choose several. None installed
                              by default. Claude Code and OpenCode only — Codex
                              has no native subagent directory.
  --kit-version <version>    Record an explicit kit version instead of the
                              auto-detected Git tag (or commit, if untagged).
  --help                     Show this help.

Examples:
  scripts/install.sh --target ../my-product --runtime claude
  scripts/install.sh --target ../my-product --runtime codex --runtime opencode
  scripts/install.sh --target ../my-product --runtime claude --skill kickoff --skill feature
  scripts/install.sh --target ../my-product --runtime claude --agent tech-lead --agent product-designer
EOF
}

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

has_value() {
  local value="$1"
  local candidate
  shift
  for candidate in "$@"; do
    [[ "$candidate" == "$value" ]] && return 0
  done
  return 1
}

KIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
TARGET=""
KIT_VERSION=""
RUNTIMES=()
REQUESTED_SKILLS=()
REQUESTED_AGENTS=()
DEFAULT_SKILLS=(kickoff feature requirements-quality product-design quality-release)

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      [[ $# -ge 2 ]] || fail "--target requires a directory"
      TARGET="$2"
      shift 2
      ;;
    --runtime)
      [[ $# -ge 2 ]] || fail "--runtime requires a runtime name"
      case "$2" in
        claude|codex|opencode)
          if [[ ${#RUNTIMES[@]} -eq 0 ]] || ! has_value "$2" "${RUNTIMES[@]}"; then
            RUNTIMES+=("$2")
          fi
          ;;
        *) fail "unsupported runtime: $2" ;;
      esac
      shift 2
      ;;
    --skill)
      [[ $# -ge 2 ]] || fail "--skill requires a skill name"
      if [[ ${#REQUESTED_SKILLS[@]} -eq 0 ]] || ! has_value "$2" "${REQUESTED_SKILLS[@]}"; then
        REQUESTED_SKILLS+=("$2")
      fi
      shift 2
      ;;
    --agent)
      [[ $# -ge 2 ]] || fail "--agent requires an agent name"
      if [[ ${#REQUESTED_AGENTS[@]} -eq 0 ]] || ! has_value "$2" "${REQUESTED_AGENTS[@]}"; then
        REQUESTED_AGENTS+=("$2")
      fi
      shift 2
      ;;
    --kit-version)
      [[ $# -ge 2 ]] || fail "--kit-version requires a value"
      KIT_VERSION="$2"
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      fail "unknown option: $1"
      ;;
  esac
done

[[ -n "$TARGET" ]] || fail "--target is required"
[[ ${#RUNTIMES[@]} -gt 0 ]] || fail "at least one --runtime is required"
[[ -d "$TARGET" ]] || fail "target directory does not exist: $TARGET"
TARGET="$(cd "$TARGET" && pwd -P)"
[[ "$TARGET" != "$KIT_ROOT" ]] || fail "target must be a product directory, not the kit checkout"

if [[ ${#REQUESTED_SKILLS[@]} -gt 0 ]]; then
  SKILLS=("${REQUESTED_SKILLS[@]}")
else
  SKILLS=("${DEFAULT_SKILLS[@]}")
fi

for skill in "${SKILLS[@]}"; do
  [[ -f "$KIT_ROOT/skills/$skill/SKILL.md" ]] || fail "unknown skill: $skill"
done

AGENTS=()
if [[ ${#REQUESTED_AGENTS[@]} -gt 0 ]]; then
  AGENTS=("${REQUESTED_AGENTS[@]}")
fi
if [[ ${#AGENTS[@]} -gt 0 ]]; then
  for agent in "${AGENTS[@]}"; do
    [[ -f "$KIT_ROOT/agents/$agent.md" ]] || fail "unknown agent: $agent"
  done
fi

runtime_agent_dir() {
  case "$1" in
    claude) printf '.claude/agents' ;;
    opencode) printf '.opencode/agents' ;;
    codex) printf '' ;;
  esac
}

if [[ ${#AGENTS[@]} -gt 0 ]]; then
  AGENT_CAPABLE_RUNTIMES=()
  for runtime in "${RUNTIMES[@]}"; do
    [[ -z "$(runtime_agent_dir "$runtime")" ]] || AGENT_CAPABLE_RUNTIMES+=("$runtime")
  done
  [[ ${#AGENT_CAPABLE_RUNTIMES[@]} -gt 0 ]] || fail "none of the selected runtimes support subagents (codex has no native subagent directory); drop --agent or add --runtime claude/opencode"
fi

if [[ -z "$KIT_VERSION" ]]; then
  KIT_VERSION="$(git -C "$KIT_ROOT" describe --tags --always 2>/dev/null || true)"
fi
[[ -n "$KIT_VERSION" ]] || fail "could not determine kit version; pass --kit-version explicitly"

CONTEXT_PATHS=(AGENTS.md CLAUDE.md PRODUCT.md DESIGN.md docs/decisions)
for relative_path in "${CONTEXT_PATHS[@]}"; do
  [[ ! -e "$TARGET/$relative_path" ]] || fail "refusing to overwrite existing $relative_path"
done

runtime_skill_dir() {
  case "$1" in
    claude) printf '.claude/skills' ;;
    codex) printf '.agents/skills' ;;
    opencode) printf '.opencode/skills' ;;
  esac
}

for runtime in "${RUNTIMES[@]}"; do
  skill_dir="$(runtime_skill_dir "$runtime")"
  for skill in "${SKILLS[@]}"; do
    [[ ! -e "$TARGET/$skill_dir/$skill" ]] || fail "refusing to overwrite existing $skill_dir/$skill"
  done
done

if [[ ${#AGENTS[@]} -gt 0 ]]; then
  for runtime in "${RUNTIMES[@]}"; do
    agent_dir="$(runtime_agent_dir "$runtime")"
    [[ -n "$agent_dir" ]] || continue
    for agent in "${AGENTS[@]}"; do
      [[ ! -e "$TARGET/$agent_dir/$agent.md" ]] || fail "refusing to overwrite existing $agent_dir/$agent.md"
    done
  done
fi

mkdir -p "$TARGET/docs/decisions"
cp "$KIT_ROOT/templates/product/AGENTS.md" "$TARGET/AGENTS.md"
cp "$KIT_ROOT/templates/product/CLAUDE.md" "$TARGET/CLAUDE.md"
cp "$KIT_ROOT/templates/product/DESIGN.md" "$TARGET/DESIGN.md"
cp "$KIT_ROOT/templates/product/docs/decisions/README.md" "$TARGET/docs/decisions/README.md"
cp "$KIT_ROOT/templates/product/docs/decisions/TEMPLATE.md" "$TARGET/docs/decisions/TEMPLATE.md"

case "$KIT_VERSION" in
  *$'\n'*|*$'\r'*) fail "kit version must not contain line breaks" ;;
esac
yaml_version="$(printf '%s' "$KIT_VERSION" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g')"
escaped_version="$(printf '%s' "$yaml_version" | sed 's/[\\&|]/\\&/g')"
escaped_date="$(date +%F | sed 's/[&|]/\\&/g')"
product_tmp="$(mktemp "$TARGET/.product-workflow-kit.XXXXXX")"
trap 'rm -f "$product_tmp"' EXIT
sed \
  -e "s|{{WORKFLOW_KIT_VERSION}}|$escaped_version|g" \
  -e "s|{{DATE}}|$escaped_date|g" \
  "$KIT_ROOT/templates/product/PRODUCT.md" > "$product_tmp"
mv "$product_tmp" "$TARGET/PRODUCT.md"
trap - EXIT

for runtime in "${RUNTIMES[@]}"; do
  skill_dir="$(runtime_skill_dir "$runtime")"
  mkdir -p "$TARGET/$skill_dir"
  for skill in "${SKILLS[@]}"; do
    cp -R "$KIT_ROOT/skills/$skill" "$TARGET/$skill_dir/$skill"
  done
done

SKIPPED_AGENT_RUNTIMES=()
if [[ ${#AGENTS[@]} -gt 0 ]]; then
  for runtime in "${RUNTIMES[@]}"; do
    agent_dir="$(runtime_agent_dir "$runtime")"
    if [[ -z "$agent_dir" ]]; then
      SKIPPED_AGENT_RUNTIMES+=("$runtime")
      continue
    fi
    mkdir -p "$TARGET/$agent_dir"
    for agent in "${AGENTS[@]}"; do
      cp "$KIT_ROOT/agents/$agent.md" "$TARGET/$agent_dir/$agent.md"
    done
  done
fi

printf 'Installed Product Workflow Kit %s into %s\n' "$KIT_VERSION" "$TARGET"
printf 'Configured runtimes: %s\n' "${RUNTIMES[*]}"
printf 'Installed skills: %s\n' "${SKILLS[*]}"
if [[ ${#AGENTS[@]} -gt 0 ]]; then
  printf 'Installed agents: %s\n' "${AGENTS[*]}"
  if [[ ${#SKIPPED_AGENT_RUNTIMES[@]} -gt 0 ]]; then
    printf 'Skipped agents for runtime(s) without a subagent directory: %s\n' "${SKIPPED_AGENT_RUNTIMES[*]}"
  fi
fi
printf 'No global configuration, hooks, plugins, permissions, or connectors were changed.\n'
