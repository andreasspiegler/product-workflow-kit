# Agent sandbox (Dev Container)

Agents work on this product inside a container instead of directly on the host. If something goes wrong, only the container is affected; `.devcontainer/dev rebuild` recreates it. Installed by the Product Workflow Kit (`scripts/add-sandbox.sh --level container`); the decision is recorded in `PRODUCT.md` under "Agent isolation".

Requirements on the host: Docker and Node.js (`npx` runs a pinned `@devcontainers/cli`).

## Use (on the host, in the repository root)

```bash
.devcontainer/dev              # Claude Code in the sandbox
.devcontainer/dev shell        # shell in the sandbox
.devcontainer/dev run <cmd>    # one command, e.g. the test suite
.devcontainer/dev rebuild      # after changes to .devcontainer/
.devcontainer/dev stop
```

On first start, run `/login` in Claude Code once. The login lives in a Docker volume, separate from the host.

If the product serves a local web app, `.devcontainer/expose.sh <start command>` makes it reachable on the host's loopback at the port configured during setup.

## What the sandbox sees and may do

| | |
| --- | --- |
| Files | Only this repository at `/workspace`. Not the host's home directory, SSH keys, tokens, or Docker socket |
| Read-only | `.git/config`, `.git/hooks`, `.devcontainer/`, `.claude/`: files the host executes or evaluates |
| Network | HTTPS only, to Anthropic (Claude Code and login) and the stack's package registry (`init-firewall.sh`). No GitHub, host, LAN, or IPv6 |
| Resources | At most 4 GB RAM and 2 CPUs |
| Root | No. `sudo` only for the firewall script |

Pushes and pull requests happen on the host; the sandbox has no GitHub credentials.

## Limits

- An agent can change or delete anything in the repository except the read-only paths. Protection: the Git remote and host backups or snapshots.
- Code changed in the sandbox runs on the host as soon as you start tests, scripts, or the app there. Review the diff first.
- DNS is open only to the configured resolver, but not filtered by content.
- Add domains in `init-firewall.sh`, then `.devcontainer/dev rebuild`.
- Versions (base image, Claude Code, devcontainer CLI) are pinned. Update them in `Dockerfile` or `dev` and rebuild.
- Only Claude Code is installed. Other agents need their own installation and firewall entries.
