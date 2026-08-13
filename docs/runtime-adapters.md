# Runtime adapters

The workflow kit has one portable core and thin adapters. The portable core is `AGENTS.md`, the `skills/` directories, and the templates copied into each product. Do not maintain separate workflow copies for every runtime.

## Product-local setup

Keep the product context in the product repository. Copy the files from `templates/product/`, then replace `{{WORKFLOW_KIT_VERSION}}` with the kit Git commit or release tag used for the setup. This makes a kickoff reproducible without silently fetching a newer remote version.

Use a deliberate kit update, review the change, and record the new version only when a product opts in.

| Runtime | Portable core | Runtime-specific adapter |
| --- | --- | --- |
| Claude Code | `AGENTS.md`, selected `skills/*/SKILL.md`, product templates | `.claude/skills/`, `.claude/agents/`, permissions and hooks |
| Codex | `AGENTS.md`, selected `skills/*/SKILL.md`, product templates | `.agents/skills/` and Codex-specific configuration |
| OpenCode | `AGENTS.md`, selected `skills/*/SKILL.md`, product templates | `.opencode/skills/`, `.opencode/agents/`, provider and permission configuration |

The local skill directory can be a copy or a symlink depending on the team's update policy. Prefer a versioned copy for a stable project; a symlink is useful only when the project intentionally tracks local kit changes.

## What does not travel unchanged

Hooks, plugin manifests, model permissions, browser access, MCP connectors, and subagent configuration are runtime-specific. They remain opt-in adapters and should never be installed globally by default. A project can use the same product workflow without having identical configuration files.

## Runtime-neutral operating model

1. Start from the product context and the current GitHub issue.
2. Triage the risk and select the smallest useful workflow.
3. Use design, research, technical, and QA help only where they reduce a real uncertainty.
4. Keep GitHub for work state; keep only durable context and decisions in the repository.
5. Verify proportionately, then assess the product outcome after release where it matters.
