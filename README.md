# Product Workflow Kit

A portable, risk-based workflow kit for building digital products with Claude Code, Codex, or OpenCode.

V3 keeps the shift away from a rigid multi-agent pipeline: one shared product context, selective specialist work, deliberate human decisions, and outcome learning after launch. GitHub Issues remain the default work record when GitHub is chosen.

> V3 is the current state of `main`; the legacy V1 commands and hook were removed in v3.0.0. Since then the kit has added explicit optional-tool state in `PRODUCT.md`, quality-aid decisions in the work record, a design read and fitting Impeccable offers before UI direction, purposeful motion and complexity checks, an optional web-interface review, root-cause debugging and fresh completion evidence, the surgical-changes rule, an installer smoke test, and explicit data, privacy, environment, misuse, and first-launch readiness checks. Run `git tag -l` for released versions.

## The model

```text
Workflow Kit (versioned Git repository)
        │ explicit local update
        ▼
Product-local context (pinned kit commit)
  ├── AGENTS.md       shared working agreement
  ├── PRODUCT.md      outcome, scope, constraints, data, environments, success signal
  ├── DESIGN.md       reusable experience and design direction
  └── docs/decisions/ durable decisions and contracts
        │
        ▼
Runtime adapters
  Claude Code · Codex · OpenCode
```

The Git repository is the source of the kit. Each product uses a reviewed local copy or symlink and records the exact kit Git commit or release tag in `PRODUCT.md`. A kickoff never silently downloads a newer remote revision.

## From idea to product

The kit is a loop, not a pipeline. Every change starts from product context, passes a risk triage, is built as a small slice, and is verified before release. Everything else — sharper requirements, decision records, design work — is added only when the triage finds a risk it would reduce.

```text
Idea
 │  kickoff ─────────────────► PRODUCT.md · DESIGN.md · risk triage
 ▼
Slice as issue ──────────────► scope, non-goals, acceptance criteria
 │  requirements-quality         only if the requirement is ambiguous or high-impact
 │  product-design               only with real experience or accessibility risk
 │  docs/decisions/              only for decisions that outlive the issue
 ▼
Build ── feature ────────────► smallest correct change, scoped diff
 ▼
Verify & release ── quality-release ► evidence, explicit release approval
 ▼
Learn ───────────────────────► outcome signal → iterate · scale · stop · investigate
 │
 └──► next slice via feature
```

| Step | Question it answers | Skill | Result | Skip when |
| --- | --- | --- | --- | --- |
| Frame the product | What outcome, for whom, within which constraints? | [`kickoff`](skills/kickoff/SKILL.md) | `PRODUCT.md` (including data, privacy, and environments), `DESIGN.md`, pinned kit version, risk triage, optional feature map as issues | The product already has current context — start with `feature`. |
| Cut a slice | What is the smallest testable step? | `kickoff` or `feature` | Issue with problem, non-goals, acceptance criteria, selected risk work, human gates | Never. |
| Sharpen the specification | What exactly must be true, including conditions and failure cases? | [`requirements-quality`](skills/requirements-quality/SKILL.md) | Clearer acceptance criteria in the same issue | The requirement is clear and low-risk. |
| Record durable decisions | Which decision or contract must outlive this issue? | Any step; optional [`sot-builder`](skills/sot-builder/SKILL.md) for a guided record | Record in `docs/decisions/` from its `TEMPLATE.md` | The decision only matters inside the issue or pull request. |
| Shape the experience | Does the journey, interface, or content work for real users? | [`product-design`](skills/product-design/SKILL.md) | Design read, flow or UI direction, updates to `DESIGN.md` | The change has no meaningful UI, interaction, content, or accessibility risk. |
| Build | What is the smallest correct change? | [`feature`](skills/feature/SKILL.md) | Pull request whose every line traces to the issue | Never. |
| Verify and release | Does it meet the criteria, and is it safe to ship? | [`quality-release`](skills/quality-release/SKILL.md) | Verification record mapping each criterion to evidence, rollback path, explicit release approval, first-launch readiness, production smoke check | Never skip verification; its depth scales with risk. |
| Learn | Did the change achieve the intended outcome? | `quality-release` | Outcome check: signal, window, owner, and the decision it informs | The change has no material intended outcome. |

There is no separate specification document. The specification of a slice lives in its issue as acceptance criteria; only decisions and contracts that must outlive the issue move into `docs/decisions/`. The repository keeps durable context, the tracker keeps work state.

Human decision gates stay explicit at every step: consequential choices, external resources, paid tools, and releases wait for approval. [`examples/microsite`](examples/microsite/) shows a filled `PRODUCT.md`, `DESIGN.md`, and one decision record for calibrating depth.

## What V3 establishes

| Earlier setup | V3 |
| --- | --- |
| Fixed seven-phase pipeline | Risk triage selects only discovery, design, technical, quality, and release work that is useful. |
| Handoff documents and `STATUS.md` | GitHub Issues track work state; a Project is optional when a board or roadmap adds coordination value. The repository contains only durable product, design, and decision context. |
| Nano Banana → v0 as the design path | Reference discovery, Claude Design, Impeccable, image generation, and v0 are selected for a concrete purpose. |
| One Claude Code setup | Portable core plus thin, project-local adapters for Claude Code, Codex, and OpenCode. |
| Deployment as the finish line | Relevant releases include a post-launch signal and a decision to iterate, scale, stop, or investigate. |

## Skills

| Skill | Installed by default | Use it for |
| --- | --- | --- |
| [`kickoff`](skills/kickoff/SKILL.md) | Yes | Starting a new product and creating credible, pinned product context. |
| [`feature`](skills/feature/SKILL.md) | Yes | Extending an existing product from its current context and risk profile. |
| [`requirements-quality`](skills/requirements-quality/SKILL.md) | Yes | Clarifying complex, high-impact, or uncertain requirements directly in their issue. |
| [`product-design`](skills/product-design/SKILL.md) | Yes | User journeys, reference discovery, design systems, motion/3D decisions, UX/a11y review, and optional design tools. |
| [`quality-release`](skills/quality-release/SKILL.md) | Yes | Proportionate tests, release readiness, rollout risk, and outcome checks. |
| [`sot-builder`](skills/sot-builder/SKILL.md) | No — select with `--skill` | Guided durable decision and contract records; the name is kept for compatibility. |
| [`nano-banana`](skills/nano-banana/SKILL.md) | No — select with `--skill` | Optional, authorized visual exploration only. |

The role briefs in [`agents/`](agents/) are specialist perspectives, not an obligatory relay race. The main conversation owns scope and cross-cutting decisions; delegate only bounded independent questions. See [`agents/README.md`](agents/README.md) for which specialist fits which question, and install one with `--agent <name>` below.

## Start a product with a pinned kit version

From the workflow kit checkout, install the shared context and selected skills into an existing product repository:

```bash
./scripts/install.sh --target ../my-product --runtime claude
```

The installer copies the product context (`CLAUDE.md` only when Claude Code is a selected runtime), records the current kit version (nearest Git tag, or commit if untagged) and date in `PRODUCT.md`, and installs the five core skills locally (`kickoff`, `feature`, `requirements-quality`, `product-design`, `quality-release`). `--skill` replaces that default selection, so name every skill you want, including optional ones such as `sot-builder`. It refuses to overwrite existing context or skill files and never changes global configuration, hooks, plugins, permissions, or connectors.

Choose a different or additional runtime deliberately:

```bash
./scripts/install.sh --target ../my-product --runtime codex --runtime opencode
./scripts/install.sh --target ../my-product --runtime claude --skill kickoff --skill feature
```

Use `--kit-version <version>` only when installing from a non-Git kit archive or when pinning a specific release value. Then fill the outcome, user, scope, non-goals, constraints, data and privacy, environments, success signal, and optional-tool state in `PRODUCT.md`. Start the first issue only after its acceptance criteria and the selected risk-reduction work are clear.

The product can deliberately upgrade later: review the newer kit version, update the local skill copy or symlink, and record the new version in `PRODUCT.md`.

### Versioning

Releases are tagged `vMAJOR.MINOR.PATCH` on `main`. Bump MAJOR for a breaking change to a skill's contract or a template's structure, MINOR for a new skill or capability, PATCH for fixes and docs. `scripts/install.sh` pins to the nearest tag automatically; run `git tag -l` in the kit checkout to see available versions.

## Maintainer checks

Run the installer smoke test before tagging a release. It creates a temporary product directory, installs the core skills for Claude Code, Codex, and OpenCode, checks the optional-agent path, confirms overwrite protection, and checks that a Codex-only install gets no `CLAUDE.md`:

```bash
./scripts/test-install.sh
```

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

## Design references and optional capabilities

For a new surface, redesign, or unresolved direction, `product-design` actively seeks a small set of relevant references, normally three to five. Each links a specific example and explains its relevance, the principle to adapt, and its limits. Revisit the search when the direction or user context changes; routine changes within an established system do not need another search.

| Resource | Use when |
| --- | --- |
| [Dribbble](https://dribbble.com/) | Exploring typography, composition, visual directions, and interface details. |
| [Awwwards](https://www.awwwards.com/) | Studying distinctive live websites, storytelling, and interaction. |
| [Mobbin](https://mobbin.com/) | Comparing real product screens, states, and connected flows. |
| [Lummi](https://www.lummi.ai/) | Exploring image direction, illustrations, or visual assets; check rights before use. |
| [Claude Design](https://support.claude.com/en/articles/14604397-set-up-your-design-system-in-claude-design) | A new design system, inconsistent styling, or meaningful prototype alternatives warrant an explicit offer. Use a compact product brief and review the output before adopting it. |
| [GSAP](https://gsap.com/docs/v3/) | Coordinated timelines, scroll-driven storytelling, or complex SVG animation justify more than native animation. |
| [Three.js](https://threejs.org/) | Interactive product views, spatial explanations, or a defining 3D scene justify live 3D. |

Reference access uses available, authorized tools; unavailable accounts or paid access are stated as limitations. Claude Design is optional and works through a manual brief and artifact handoff when a runtime integration is unavailable. Enabled authoring tools are recorded in `PRODUCT.md`; accepted design rules belong in `DESIGN.md` and the actual product components. Slice-specific explorations stay in the issue or pull request.

GSAP and Three.js are implementation options, not bundled dependencies. Choose the intended effect first, compare a simpler alternative, and assess mobile performance, accessibility, maintenance, and fallback behavior before adding a dependency. `quality-release` includes focused motion and 3D checks. None of these resources adds a mandatory phase or authorizes installation, paid access, or external publication.

## Curated external influences

These sources inform selected decision points in the kit. They are not bundled dependencies: external skills are considered only when they have been reviewed, deliberately installed project-locally from a pinned source, and explicitly approved for the task.

| Source | What the kit uses it for | How it is handled |
| --- | --- | --- |
| [Impeccable](https://impeccable.style/) | UI changes with meaningful experience risk. | `product-design` explicitly offers one fitting activity — such as `shape`, `critique`, `clarify`, `distill`, `polish`, or `audit` — at the relevant moment. An offer is not an installation or invocation. |
| [Taste Skill](https://www.tasteskill.dev/) | Establishing a UI direction before design or implementation. | The kit adopts its compact **design read**: surface or journey, user, intended interaction and visual language, and the existing system it should follow. It does not install the external skill. |
| [Emil Kowalski's skills](https://emilkowal.ski/skill) | Purposeful motion and complex interaction decisions. | The kit uses the underlying principles: motion must earn its place, established accessible primitives come before hand-rolled interactions, and motion needs targeted verification. `animate`, `review-animations`, `find-animation-opportunities`, and `prototype` remain optional local additions for dedicated work. |
| [Ponytail](https://github.com/dietrichgebert/ponytail) | Keeping implementation proportionate. | The kit adopts the implementation ladder, root-cause check, executable proof for nontrivial deterministic logic, and explicit upgrade triggers. `ponytail-review` and `ponytail-audit` are optional, project-local review aids — never an always-on plugin or a replacement for product, security, accessibility, or correctness review. |
| [Vercel Web Interface Guidelines](https://vercel.com/design/guidelines) | Checking implemented web interfaces for concrete interaction, accessibility, responsive, and browser-quality risks. | `web-design-guidelines` is an optional, project-local code audit after implementation and before acceptance or release. It reviews changed UI files, records source/date/scope, and complements rather than replaces manual browser, product, or accessibility review. Vercel-specific copy and brand preferences are not adopted as product rules. |
| [Karpathy guidelines](https://github.com/multica-ai/andrej-karpathy-skills) | Keeping diffs scoped to the request. | The kit adopts only the surgical-changes rule: no drive-by refactoring or reformatting, report unrelated dead code instead of deleting it, and trace every changed line to the work item. Its other rules are already covered by `requirements-quality` and the implementation ladder; its "fewer lines" heuristic is not adopted because simplicity is not a line-count target. It is not installed as a skill. |

The links are sources and implementation references, not recommendations to install every skill. The product-local kit remains the source of truth for which workflows are available in a product.

## Repository layout

```text
agents/                 optional specialist role briefs
docs/                   adapter guide
examples/               worked example for calibrating PRODUCT.md/DESIGN.md depth
scripts/                installer and installer smoke test
skills/                 canonical v3 workflow skills
templates/product/      product-local shared context
```

## Principles

- Product outcome before process compliance.
- One portable core; runtime-specific behavior stays in thin adapters.
- GitHub Issues track work state when selected; add a Project only for a requested board or a real coordination need. Product files capture only durable context.
- Tools create evidence, never replace user decisions.
- Risk determines depth of work and verification.
- Deployment needs explicit authorization; a product learns after it ships.
