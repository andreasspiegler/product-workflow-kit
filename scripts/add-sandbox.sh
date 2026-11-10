#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  scripts/add-sandbox.sh --target <product-directory> --level <none|agent|container> [options]

Add agent isolation to a product. Works for new products (called by install.sh)
and for existing ones. Writes only project-local files and never overwrites.

Levels:
  none        Nothing is installed; only the decision is printed for PRODUCT.md.
  agent       Claude Code sandbox and deny rules in .claude/settings.json:
              shell commands may write only inside the project, cannot read
              common credential stores, cannot reach the Docker socket, and
              cannot switch the sandbox off. Covers Claude Code only.
  container   Everything from "agent" plus a Dev Container in .devcontainer/
              with an outbound HTTPS allowlist. Agents started through
              .devcontainer/dev see only the repository. Needs Docker and Node.js.

Options for --level container:
  --stack <python|node|generic>   Toolchain for the container image. Default:
                                  python if pyproject.toml exists, node if
                                  package.json exists, otherwise generic.
  --app-port <port>               Port of a local web app inside the container,
                                  made reachable on the host's 127.0.0.1.
  --name <name>                   Name for the container and its volumes.
                                  Default: the target directory name.
  --help                          Show this help.
EOF
}

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

KIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
TEMPLATES="$KIT_ROOT/templates/sandbox"
CLAUDE_CODE_VERSION="2.1.316"
DEVCONTAINER_CLI_VERSION="0.90.0"
UV_VERSION="0.13.7"

TARGET=""
LEVEL=""
STACK=""
APP_PORT=""
NAME=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target) [[ $# -ge 2 ]] || fail "--target requires a directory"; TARGET="$2"; shift 2 ;;
    --level) [[ $# -ge 2 ]] || fail "--level requires a value"; LEVEL="$2"; shift 2 ;;
    --stack) [[ $# -ge 2 ]] || fail "--stack requires a value"; STACK="$2"; shift 2 ;;
    --app-port) [[ $# -ge 2 ]] || fail "--app-port requires a port"; APP_PORT="$2"; shift 2 ;;
    --name) [[ $# -ge 2 ]] || fail "--name requires a value"; NAME="$2"; shift 2 ;;
    --help|-h) usage; exit 0 ;;
    *) fail "unknown option: $1" ;;
  esac
done

[[ -n "$TARGET" ]] || fail "--target is required"
[[ -d "$TARGET" ]] || fail "target directory does not exist: $TARGET"
TARGET="$(cd "$TARGET" && pwd -P)"
[[ "$TARGET" != "$KIT_ROOT" ]] || fail "target must be a product directory, not the kit checkout"
case "$LEVEL" in
  none|agent|container) ;;
  "") fail "--level is required (none, agent, or container)" ;;
  *) fail "unsupported level: $LEVEL" ;;
esac
if [[ "$LEVEL" != container ]]; then
  [[ -z "$STACK$APP_PORT$NAME" ]] || fail "--stack, --app-port, and --name apply only to --level container"
fi

if [[ "$LEVEL" == none ]]; then
  printf 'Agent isolation: none. Nothing installed.\n'
  exit 0
fi

SETTINGS="$TARGET/.claude/settings.json"
[[ ! -e "$SETTINGS" ]] || fail "refusing to overwrite existing .claude/settings.json; merge templates/sandbox/claude-settings.json by hand"

if [[ "$LEVEL" == container ]]; then
  [[ -d "$TARGET/.git" ]] || fail "--level container needs a Git repository in the target (its .git/config and .git/hooks are mounted read-only)"
  [[ ! -e "$TARGET/.devcontainer" ]] || fail "refusing to overwrite existing .devcontainer/"

  if [[ -z "$STACK" ]]; then
    if [[ -f "$TARGET/pyproject.toml" ]]; then STACK=python
    elif [[ -f "$TARGET/package.json" ]]; then STACK=node
    else STACK=generic
    fi
  fi
  case "$STACK" in python|node|generic) ;; *) fail "unsupported stack: $STACK" ;; esac

  if [[ -n "$APP_PORT" ]]; then
    [[ "$APP_PORT" =~ ^[0-9]+$ ]] && (( APP_PORT >= 1 && APP_PORT <= 65535 && APP_PORT != 9999 )) \
      || fail "--app-port must be a port number between 1 and 65535 (not 9999, the relay port)"
  fi

  [[ -n "$NAME" ]] || NAME="$(basename "$TARGET")"
  NAME="$(printf '%s' "$NAME" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9-]+/-/g; s/^-+//; s/-+$//')"
  [[ -n "$NAME" ]] || fail "could not derive a container name; pass --name"
fi

# --- agent level (also part of container) ---
mkdir -p "$TARGET/.claude"
cp "$TEMPLATES/claude-settings.json" "$SETTINGS"

if [[ "$LEVEL" == agent ]]; then
  printf 'Installed Claude Code sandbox settings: .claude/settings.json\n'
  printf 'Agent isolation: agent. Covers Claude Code only; Codex and OpenCode need their own configuration.\n'
  printf 'Next: add private data directories on this machine (for example a notes vault) to\n'
  printf '      sandbox.filesystem.denyRead and to Read/Edit deny rules in .claude/settings.json.\n'
  exit 0
fi

# --- container level ---
python_version="3.12"
if [[ -f "$TARGET/.python-version" ]]; then
  candidate="$(tr -d '[:space:]' < "$TARGET/.python-version")"
  [[ "$candidate" =~ ^3\.[0-9]+$ ]] && python_version="$candidate"
fi

NL=$'\n'
STACK_TOOLS=""
STACK_DOMAINS=""
STACK_ENV=""
STACK_DIRS=""
STACK_MOUNTS=""
POST_CREATE=""
case "$STACK" in
  python)
    BASE_IMAGE="python:${python_version}-slim-bookworm"
    STACK_TOOLS="${NL}# uv for Python projects${NL}COPY --from=ghcr.io/astral-sh/uv:${UV_VERSION} /uv /uvx /usr/local/bin/${NL}"
    STACK_DOMAINS="  pypi.org${NL}  files.pythonhosted.org${NL}"
    STACK_ENV=",${NL}    \"UV_PROJECT_ENVIRONMENT\": \"/home/dev/.venv\",${NL}    \"UV_PYTHON_DOWNLOADS\": \"never\",${NL}    \"UV_LINK_MODE\": \"copy\""
    [[ -f "$TARGET/pyproject.toml" ]] && POST_CREATE="uv sync"
    ;;
  node)
    BASE_IMAGE="node:22-bookworm-slim"
    STACK_DOMAINS="  registry.npmjs.org${NL}"
    STACK_ENV=",${NL}    \"npm_config_update_notifier\": \"false\""
    # node_modules lives in a volume so container binaries never replace the host's
    STACK_DIRS=" /workspace/node_modules"
    STACK_MOUNTS=",${NL}    \"source=${NAME}-node-modules,target=/workspace/node_modules,type=volume\""
    if [[ -f "$TARGET/package-lock.json" ]]; then POST_CREATE="npm ci"
    elif [[ -f "$TARGET/package.json" ]]; then POST_CREATE="npm install"
    fi
    mkdir -p "$TARGET/node_modules"
    ;;
  generic)
    BASE_IMAGE="debian:bookworm-slim"
    ;;
esac

APP_PORT_LINE=""
[[ -z "$APP_PORT" ]] || APP_PORT_LINE="${NL}  \"appPort\": [\"127.0.0.1:${APP_PORT}:9999\"],"
POST_CREATE_LINE=""
[[ -z "$POST_CREATE" ]] || POST_CREATE_LINE="${NL}  \"postCreateCommand\": \"${POST_CREATE}\","

render() {
  local src="$1" dest="$2" content
  content="$(cat "$src")"
  content="${content//\{\{PRODUCT_NAME\}\}/$NAME}"
  content="${content//\{\{BASE_IMAGE\}\}/$BASE_IMAGE}"
  content="${content//\{\{STACK_TOOLS\}\}/$STACK_TOOLS}"
  content="${content//\{\{STACK_DOMAINS\}\}/$STACK_DOMAINS}"
  content="${content//\{\{STACK_ENV\}\}/$STACK_ENV}"
  content="${content//\{\{STACK_DIRS\}\}/$STACK_DIRS}"
  content="${content//\{\{STACK_MOUNTS\}\}/$STACK_MOUNTS}"
  content="${content//\{\{APP_PORT_LINE\}\}/$APP_PORT_LINE}"
  content="${content//\{\{APP_PORT\}\}/$APP_PORT}"
  content="${content//\{\{POST_CREATE_LINE\}\}/$POST_CREATE_LINE}"
  content="${content//\{\{CLAUDE_CODE_VERSION\}\}/$CLAUDE_CODE_VERSION}"
  content="${content//\{\{DEVCONTAINER_CLI_VERSION\}\}/$DEVCONTAINER_CLI_VERSION}"
  printf '%s\n' "$content" > "$dest"
  if grep -q '{{[A-Z_]*}}' "$dest"; then
    fail "unrendered placeholder in $dest"
  fi
}

mkdir -p "$TARGET/.devcontainer" "$TARGET/.git/hooks"
for file in devcontainer.json Dockerfile init-firewall.sh dev README.md; do
  render "$TEMPLATES/devcontainer/$file" "$TARGET/.devcontainer/$file"
done
if [[ -n "$APP_PORT" ]]; then
  render "$TEMPLATES/devcontainer/expose.sh" "$TARGET/.devcontainer/expose.sh"
  chmod +x "$TARGET/.devcontainer/expose.sh"
fi
chmod +x "$TARGET/.devcontainer/dev" "$TARGET/.devcontainer/init-firewall.sh"

printf 'Installed Claude Code sandbox settings: .claude/settings.json\n'
printf 'Installed Dev Container: .devcontainer/ (stack: %s, image: %s)\n' "$STACK" "$BASE_IMAGE"
printf 'Agent isolation: container. Start agents with .devcontainer/dev; see .devcontainer/README.md.\n'
printf 'Next: review the image and firewall domains for this product, then run .devcontainer/dev up once.\n'
