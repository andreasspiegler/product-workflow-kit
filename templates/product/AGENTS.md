# Product working agreement

This file is the runtime-neutral instruction source for this product. Runtime-specific files may point here, but must not duplicate its rules.

## Start with the current product context

Before planning or changing the product, read the relevant parts of:

1. `PRODUCT.md` for the intended outcome, scope, constraints, data and privacy, environments, and success signal.
2. `DESIGN.md` when the change affects an experience, UI, content, or interaction.
3. the linked GitHub issue or pull request for the current work item and acceptance criteria.
4. `GLOSSARY.md`, when it exists, for the product's domain terms; use them in code, tests, and issues.
5. `docs/decisions/` only when a durable decision or contract is relevant.

Read the existing code and conventions before proposing an implementation.

## Source of truth

- GitHub Issues track work status, priorities, and acceptance criteria when GitHub is the chosen tracker. Add a GitHub Project only when the user explicitly wants a board or roadmap, or when coordination needs justify it.
- `PRODUCT.md` captures durable product context.
- `DESIGN.md` captures the current design direction and system decisions.
- `GLOSSARY.md` defines the product's domain language, created when the first term is settled.
- `CODING_STANDARDS.md` holds the judgement-call rules a reviewer checks; mechanical rules belong in automated checks instead. Read it when reviewing a change.
- `docs/decisions/` records durable, consequential decisions and contracts.
- Pull requests contain implementation review and verification evidence.

Do not create parallel status files, phase handoffs, or decision logs for the same information.

## Working rules

- Begin with a short risk triage: product impact and uncertainty; UI or accessibility risk; data, privacy, security, or reliability risk; reversibility and rollout risk.
- For a user-facing UI or interaction change with meaningful experience risk, explicitly offer the single most fitting Impeccable activity as an option, with its intended gain. If it would not reduce a real risk, say why it is not needed. Never install or invoke Impeccable without explicit approval.
- For a user-facing web change with material implementation risk, offer an optional `web-design-guidelines` review after implementation and before acceptance or release. It complements, but does not replace, visual, usability, accessibility, or manual browser review. Never install or invoke it without explicit approval.
- `PRODUCT.md` records every optional tool that is actually enabled: source and version or commit, runtime path, and approval. Before invoking one, confirm that record and that the target runtime exposes it; otherwise offer adoption as a decision, not an available implementation step.
- Select only the work that reduces a meaningful risk. A small copy fix does not require a staged product process; a new flow, data migration, or high-stakes decision may.
- Keep decisions explicit. Record a decision in `docs/decisions/` only when it is hard to reverse, would surprise a future reader without its context, and came from a real trade-off between alternatives.
- Reuse the existing design system and code patterns. State uncertainty instead of inventing product facts, research, metrics, or approvals.
- For framework, API, or platform decisions, check the current documentation for the version in use rather than relying on memory.
- Never read, print, or commit secrets such as `.env` files, keys, or tokens. Access production data only with explicit approval.
- Respect the agent isolation recorded in `PRODUCT.md`. Never weaken or bypass sandbox settings, deny rules, `.claude/settings.json`, or `.devcontainer/` without explicit approval; ask for a narrow exception instead.
- Keep changes surgical: every changed line should trace to the current work item. Report unrelated cleanup instead of bundling it.
- Define how the result will be verified before implementation. For shipped changes, also state the outcome signal and measurement window when relevant.
- Do not deploy, publish, change production data, or make other external side effects without explicit approval.
- Workflow files are internal and never ship with the product: `AGENTS.md`, `CLAUDE.md`, `PRODUCT.md`, `DESIGN.md`, `docs/`, and runtime directories such as `.claude/`, `.agents/`, and `.opencode/`. When setting up or changing a deployment, exclude them from the deployed artifact. If the web root is the repository root, also block them at the web server. Check the exclude syntax of the deploy tool rather than assuming glob semantics.

## Human gates

Ask for a decision before committing to a new product direction, a consequential visual direction, an irreversible technical choice, a production release, or a material scope expansion. Summarize options, evidence, risks, and the recommended next step.

## Operating mode

`PRODUCT.md` records who resolves these gates in day-to-day work. In `human-led` mode, every gate waits for a person. In `factory` mode, the factory workflow (`.github/workflows/factory.yml` with the `factory-run` skill) resolves them for issues labelled `factory:ready` at or below the recorded autonomy ceiling: it may merge and, with `deploy: staging-auto`, deploy to staging. It never sets product direction, raises its own ceiling, changes protected paths, adds dependencies, or deploys to production; those, and everything above the ceiling, come back to a person labelled `factory:needs-human`. Interactive sessions follow the human-led rules in both modes.

## Completion

Before declaring work complete, link the implementation to its acceptance criteria, run the proportionate checks, record remaining known risks, and update the work item. For a launch, schedule or describe the post-launch outcome check; deployment alone is not product completion.
