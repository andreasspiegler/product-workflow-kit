#!/usr/bin/env bash
# Run inside the container. Makes an app that listens on 127.0.0.1:<port> inside the
# sandbox reachable on the host at 127.0.0.1:<port> (mapping in devcontainer.json).
#   .devcontainer/expose.sh <command that starts the app>
set -euo pipefail
socat TCP-LISTEN:9999,fork,reuseaddr TCP:127.0.0.1:{{APP_PORT}} &
relay=$!
trap 'kill "$relay" 2>/dev/null || true' EXIT
"$@"
