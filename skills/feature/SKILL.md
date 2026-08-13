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

Read, as relevant:

1. `AGENTS.md`, `PRODUCT.md`, and `DESIGN.md`.
2. The linked GitHub issue or pull request, including acceptance criteria and prior decisions.
3. Existing code, tests, component patterns, deployment configuration, and affected contracts.
4. `docs/decisions/` only when a durable decision or contract is involved.

State missing context and do not assume that existing behavior is accidental or wrong.

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

## 4. Verify, release, learn

Before completion, verify the relevant acceptance criteria, regression risks, and accessibility or operational risks. Summarize what was checked and what remains uncertain in the pull request.

Ask for explicit approval before a production deployment or other external side effect. For a released change with a material intended outcome, state the signal, measurement window, and decision that will follow from the result.
