# Product working agreement

This file is the runtime-neutral instruction source for this product. Runtime-specific files may point here, but must not duplicate its rules.

## Start with the current product context

Before planning or changing the product, read the relevant parts of:

1. `PRODUCT.md` for the intended outcome, scope, constraints, and success signal.
2. `DESIGN.md` when the change affects an experience, UI, content, or interaction.
3. the linked GitHub issue or pull request for the current work item and acceptance criteria.
4. `docs/decisions/` only when a durable decision or contract is relevant.

Read the existing code and conventions before proposing an implementation.

## Source of truth

- GitHub Issues track work status, priorities, and acceptance criteria when GitHub is the chosen tracker. Add a GitHub Project only when the user explicitly wants a board or roadmap, or when coordination needs justify it.
- `PRODUCT.md` captures durable product context.
- `DESIGN.md` captures the current design direction and system decisions.
- `docs/decisions/` records durable, consequential decisions and contracts.
- Pull requests contain implementation review and verification evidence.

Do not create parallel status files, phase handoffs, or decision logs for the same information.

## Working rules

- Begin with a short risk triage: product impact and uncertainty; UI or accessibility risk; data, privacy, security, or reliability risk; reversibility and rollout risk.
- Select only the work that reduces a meaningful risk. A small copy fix does not require a staged product process; a new flow, data migration, or high-stakes decision may.
- Keep decisions explicit. Record a decision only when it needs to survive the current issue or pull request.
- Reuse the existing design system and code patterns. State uncertainty instead of inventing product facts, research, metrics, or approvals.
- Define how the result will be verified before implementation. For shipped changes, also state the outcome signal and measurement window when relevant.
- Do not deploy, publish, change production data, or make other external side effects without explicit approval.

## Human gates

Ask for a decision before committing to a new product direction, a consequential visual direction, an irreversible technical choice, a production release, or a material scope expansion. Summarize options, evidence, risks, and the recommended next step.

## Completion

Before declaring work complete, link the implementation to its acceptance criteria, run the proportionate checks, record remaining known risks, and update the work item. For a launch, schedule or describe the post-launch outcome check; deployment alone is not product completion.
