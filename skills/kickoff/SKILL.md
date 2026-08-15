---
name: kickoff
description: >-
  Start a new product with a portable, risk-based workflow. Use when a user
  wants to create a product, application, service, or substantial new project.
  Establishes product context, chooses only needed discovery/design/technical
  work, and creates a verification and outcome plan.
---

# Kickoff

Build a shared understanding of the outcome first. Do not run a fixed pipeline or create repositories, issues, projects, external accounts, or deployments without explicit approval.

## 1. Orient

If a repository already exists, read its `AGENTS.md`, `PRODUCT.md`, `DESIGN.md`, relevant decisions, and current GitHub work items before proposing a plan. For a new product, gather only the missing essentials:

- intended outcome and primary user;
- existing evidence, assets, constraints, and non-goals;
- important uncertainties and decisions;
- success signal and a plausible measurement window;
- whether GitHub is the desired work tracker and where the product should live.

Do not invent a target user, a business case, a stack, or a deployment platform.

## 2. Establish portable context

With approval, create the product-local context from `templates/product/`:

- `AGENTS.md` as the shared working agreement;
- `CLAUDE.md` as the thin Claude Code adapter to that agreement;
- `PRODUCT.md` as durable product context;
- `DESIGN.md` when the product has an experience surface;
- `docs/decisions/` only for decisions that must outlive an issue or pull request.

Record the workflow kit's Git commit or release tag in `PRODUCT.md`. This pins the kickoff to the kit version actually used; it must not silently follow a newer remote revision.

When GitHub is the chosen tracker, use GitHub Issues as the default work record for status, priorities, requirements, and acceptance criteria. Add a GitHub Project only when the user explicitly asks for a board or roadmap, or when the volume and coordination needs make it materially useful. Do not create a Project merely to satisfy the workflow. Do not use a parallel phase handoff or `STATUS.md`.

## 3. Triage the work

State the risk assessment before choosing contributors or artifacts:

| Risk | Ask |
| --- | --- |
| Product | Is the outcome, user, or demand materially uncertain? |
| Experience | Is a new journey, UI pattern, content model, or accessibility decision involved? |
| Technical | Are data, privacy, security, reliability, integrations, or irreversible choices involved? |
| Delivery | What is the blast radius, rollback path, and post-launch outcome check? |

Select only the necessary activities. Examples:

- A focused prototype may need discovery and a lightweight design review, but no architecture record.
- A new data boundary may need a technical decision, security review, and rollout plan even with little UI work.
- A straightforward known-pattern build may move directly to an issue, implementation plan, and proportionate verification.

Use specialized agents or skills only for bounded questions that benefit from parallel expertise. The main conversation owns prioritization and cross-cutting decisions.

## 4. Create an executable first slice

Propose the smallest testable slice with:

- a clearly bounded problem and non-goals;
- issue-level acceptance criteria and dependencies;
- the design, research, technical, and quality work selected by the triage;
- a human decision gate for consequential choices;
- verification evidence required before release;
- a post-release outcome check when the slice ships.

Wait for explicit direction before crossing a human gate, creating external resources, spending paid credits, or releasing to users.

## Completion of kickoff

A kickoff is complete when the product context is credible, the first slice can be started without guessing, ownership and decision gates are clear, and the next work item is ready. It is not complete merely because a repository or backlog exists.
