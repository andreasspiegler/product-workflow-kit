---
name: feature
description: >-
  Develop a change in an existing product using a portable, risk-based workflow.
  Use for features, improvements, fixes, and changes to an established codebase.
  It begins from existing product context and scales discovery, design,
  architecture, and verification to the actual risk.
---

# Feature

Start from the product and its current codebase, not a generic seven-phase workflow.

## 1. Reconstruct context

Start with targeted local search (for example `rg`) to identify the affected files, symbols, tests, and existing conventions. Open only the smallest relevant context before expanding the search. Then read, as relevant:

1. `AGENTS.md`, `PRODUCT.md`, and `DESIGN.md`.
2. The linked GitHub issue or pull request, including acceptance criteria and prior decisions.
3. Existing code, tests, component patterns, deployment configuration, and affected contracts.
4. `docs/decisions/` only when a durable decision or contract is involved.

State missing context and do not assume that existing behavior is accidental or wrong.

## Prefer the smallest correct change

Once the affected flow is understood, choose the first option that fully resolves the need:

1. no change, if the product already behaves as intended;
2. reuse an existing product pattern or code path;
3. use the standard library or native platform capability;
4. use an already installed, suitable dependency;
5. only then add the minimum new code or dependency.

For a bug, trace callers and the shared flow before editing the visible symptom; fix the root cause when that is the safer, contained choice. Simplicity is not a line-count target: do not trade away accessibility, security, authorization, error handling, or an established product contract for a smaller diff.

## Debug unexpected behavior before fixing

When a test, build, integration, performance check, or product behavior fails unexpectedly, investigate before proposing a fix. Start with the exact failure, a reproducible path where feasible, relevant recent changes, and the data or state at the boundary where the behavior diverges. Compare it with a working product pattern when one exists.

State one concrete root-cause hypothesis and test it with the smallest useful change or observation. Do not stack speculative fixes or bundle unrelated refactoring while the cause is unknown. If three evidence-backed attempts fail, stop and summarize what is known; discuss whether the architecture, contract, or initial assumption needs to change before attempting a fourth fix.

## 2. Triage before planning

Assess product uncertainty, experience/accessibility risk, technical/data/security risk, and rollout/reversibility. Explain the smallest useful path:

| Change shape | Typical path |
| --- | --- |
| Isolated copy or visual correction | Confirm intent, implement within the existing pattern, and perform a focused check. |
| Known-pattern feature | Issue acceptance criteria, implementation plan, targeted tests, and relevant manual verification. |
| New user journey or design-system change | Use `product-design` before implementation and ask for a decision where direction matters. |
| Data, auth, payment, integration, or architecture change | Obtain technical review, record a durable decision only if needed, and plan rollback plus stronger verification. |
| High-impact release | Add staged rollout, observability, explicit release approval, and an outcome check. |

`nano`, `micro`, `standard`, and `large` may be useful shorthand, but they never automatically remove verification or human approval required by risk.

## 3. Work the slice

Keep the issue and pull request as the work record. Make acceptance criteria, design evidence, implementation choices, checks, and remaining risks easy to find. Keep reusable product and design direction in `PRODUCT.md` or `DESIGN.md`; keep durable decisions in `docs/decisions/`.

Use the `product-design` and `quality-release` skills when they address identified uncertainty. Do not require a mockup, image generator, v0, new ADR, or a global status file merely because the workflow has them available.

For a complex interaction primitive — for example a dialog, popover, menu, select, toast, drag-and-drop interaction, or virtualized list — first inspect the product's existing library and patterns. Reuse them when suitable. If none is suitable, evaluate a maintained accessible primitive before hand-rolling interaction, focus, dismissal, or keyboard behavior; ask before adding a dependency.

When an intentional simplification has a known ceiling, record that ceiling and a concrete upgrade trigger in the issue or durable decision record. Do not create a separate debt ledger or leave the essential rationale only in a code comment.

For an explicit complexity review, use `ponytail-review` on the current diff only when it has been deliberately installed project-locally from a reviewed, pinned source. For a one-off whole-repository simplification audit, use `ponytail-audit` on the same basis. They complement — never replace — correctness, accessibility, security, and product review.

## 4. Verify, release, learn

Before completion, verify the relevant acceptance criteria, regression risks, and accessibility or operational risks. Summarize what was checked and what remains uncertain in the pull request.

Ask for explicit approval before a production deployment or other external side effect. For a released change with a material intended outcome, state the signal, measurement window, and decision that will follow from the result.
