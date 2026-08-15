# Product Workflow Kit

A portable, risk-based workflow kit for building digital products with Claude Code, Codex, or OpenCode.

V2 replaces a rigid multi-agent pipeline with one shared product context and selective specialist work. It keeps human decisions deliberate, uses GitHub Issues as the default work record when GitHub is chosen, and treats launch as the start of outcome learning—not the end of the work.

> V2 is currently introduced on `feat/v2-portable-workflow-kit`. The legacy V1 commands and hook remain in the repository only to avoid breaking existing installs; new setups should use the V2 skills and templates.

## The model

```text
Workflow Kit (versioned Git repository)
        │ explicit local update
        ▼
Product-local context (pinned kit commit)
  ├── AGENTS.md       shared working agreement
  ├── PRODUCT.md      outcome, scope, constraints, success signal
  ├── DESIGN.md       reusable experience and design direction
  └── docs/decisions/ durable decisions and contracts
        │
        ▼
Runtime adapters
  Claude Code · Codex · OpenCode
```

The Git repository is the source of the kit. Each product uses a reviewed local copy or symlink and records the exact kit Git commit or release tag in `PRODUCT.md`. A kickoff never silently downloads a newer remote revision.

## What V2 changes

| V1 | V2 |
| --- | --- |
| Fixed seven-phase pipeline | Risk triage selects only discovery, design, technical, quality, and release work that is useful. |
| Handoff documents and `STATUS.md` | GitHub Issues track work state; a Project is optional when a board or roadmap adds coordination value. The repository contains only durable product, design, and decision context. |
| Nano Banana → v0 as the design path | Impeccable, image generation, and v0 are optional tools selected for a concrete purpose. |
| One Claude Code setup | Portable core plus thin, project-local adapters for Claude Code, Codex, and OpenCode. |
| Deployment as the finish line | Relevant releases include a post-launch signal and a decision to iterate, scale, stop, or investigate. |

## Core skills

| Skill | Use it for |
| --- | --- |
| [`kickoff`](skills/kickoff/SKILL.md) | Starting a new product and creating credible, pinned product context. |
| [`feature`](skills/feature/SKILL.md) | Extending an existing product from its current context and risk profile. |
| [`requirements-quality`](skills/requirements-quality/SKILL.md) | Clarifying complex, high-impact, or uncertain requirements directly in their issue. |
| [`product-design`](skills/product-design/SKILL.md) | User journeys, interaction direction, system decisions, UX/a11y review, and optional Impeccable usage. |
| [`quality-release`](skills/quality-release/SKILL.md) | Proportionate tests, release readiness, rollout risk, and outcome checks. |
| [`sot-builder`](skills/sot-builder/SKILL.md) | V2 compatibility name for durable decision and contract records. |
| [`nano-banana`](skills/nano-banana/SKILL.md) | Optional, authorized visual exploration only. |

The role briefs in [`agents/`](agents/) are specialist perspectives, not an obligatory relay race. The main conversation owns scope and cross-cutting decisions; delegate only bounded independent questions.

## Start a product with a pinned kit version

From the workflow kit checkout, install the shared context and selected skills into an existing product repository:

```bash
./scripts/install.sh --target ../my-product --runtime claude
```

The installer copies the product context, records the current kit Git commit and date in `PRODUCT.md`, and installs the five core skills locally. It refuses to overwrite existing context or skill files and never changes global configuration, hooks, plugins, permissions, or connectors.

Choose a different or additional runtime deliberately:

```bash
./scripts/install.sh --target ../my-product --runtime codex --runtime opencode
./scripts/install.sh --target ../my-product --runtime claude --skill kickoff --skill feature
```

Use `--kit-version <version>` only when installing from a non-Git kit archive or when pinning a specific release value. Then fill the outcome, user, scope, non-goals, constraints, and success signal in `PRODUCT.md`. Start the first issue only after its acceptance criteria and the selected risk-reduction work are clear.

The product can deliberately upgrade later: review the newer kit version, update the local skill copy or symlink, and record the new version in `PRODUCT.md`.

## Manual installation

Use the installer above for normal setup. The following project-local copy examples remain available for teams that need a deliberately custom installation; symlinks are appropriate only when the project intentionally follows changes in a local kit checkout.

### Claude Code

```bash
mkdir -p .claude/skills
cp -R "$WORKFLOW_KIT/skills/kickoff" "$WORKFLOW_KIT/skills/feature" \
  "$WORKFLOW_KIT/skills/requirements-quality" "$WORKFLOW_KIT/skills/product-design" \
  "$WORKFLOW_KIT/skills/quality-release" \
  .claude/skills/
```

Use the role briefs only when the team wants Claude Code subagents, by adapting selected files from `agents/` into `.claude/agents/`. Project hooks and permissions remain explicit, project-local choices.

### Codex

```bash
mkdir -p .agents/skills
cp -R "$WORKFLOW_KIT/skills/kickoff" "$WORKFLOW_KIT/skills/feature" \
  "$WORKFLOW_KIT/skills/requirements-quality" "$WORKFLOW_KIT/skills/product-design" \
  "$WORKFLOW_KIT/skills/quality-release" \
  .agents/skills/
```

Keep `AGENTS.md` in the product root. Configure only the Codex-specific agent, permission, or connector capabilities actually needed by the product.

### OpenCode

```bash
mkdir -p .opencode/skills
cp -R "$WORKFLOW_KIT/skills/kickoff" "$WORKFLOW_KIT/skills/feature" \
  "$WORKFLOW_KIT/skills/requirements-quality" "$WORKFLOW_KIT/skills/product-design" \
  "$WORKFLOW_KIT/skills/quality-release" \
  .opencode/skills/
```

OpenCode can also discover project skills in `.agents/skills/`; use one local convention per product. Put OpenCode-specific agents, providers, and permissions in `.opencode/` only when required.

See [runtime adapters](docs/runtime-adapters.md) for the portability boundary and update policy.

## Product operating model

1. Read the product context, existing code, and the active GitHub issue or pull request.
2. Triage product, experience, technical, and delivery risk.
3. Select the smallest activities that remove meaningful uncertainty.
4. Keep acceptance criteria and work status in the chosen tracker; keep durable context in the repository.
5. Verify proportionately. Before an external release, ask for explicit approval.
6. For meaningful launches, check the intended outcome and decide what to do next.

## Impeccable

[Impeccable](https://impeccable.style/) is a useful optional addition to the design step. When it is installed for the target runtime, the V2 design skill uses `shape`, `document`, `polish`, and `audit` as situational help—not as an automatic dependency. Its hooks and provider configuration must remain project-local and opt-in.

## Migrating a V1 project

Read [V1 to V2 migration](docs/v2-migration.md). In short: add the product templates, move only still-relevant durable rules to `docs/decisions/`, stop using phase handoffs and `STATUS.md`, and do not install the legacy session-start hook.

## Repository layout

```text
agents/                 optional specialist role briefs
commands/               V1 compatibility only; not for new V2 setups
docs/                   adapter guide and migration notes
skills/                 canonical V2 workflow skills
templates/product/      product-local shared context
hooks/                  V1 hook retained for existing projects only
```

## Principles

- Product outcome before process compliance.
- One portable core; runtime-specific behavior stays in thin adapters.
- GitHub Issues track work state when selected; add a Project only for a requested board or a real coordination need. Product files capture only durable context.
- Tools create evidence, never replace user decisions.
- Risk determines depth of work and verification.
- Deployment needs explicit authorization; a product learns after it ships.
