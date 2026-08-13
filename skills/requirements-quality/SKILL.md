---
name: requirements-quality
description: >-
  Improve complex, high-impact, or uncertain product requirements before
  implementation. Use when acceptance criteria are ambiguous, behavior has
  important conditions or failure cases, assumptions are hidden, or a decision
  needs clearer evidence. Keep the GitHub Issue as the work record; do not use
  for routine low-risk changes that are already clear.
---

# Requirements quality

Use this skill to clarify a decision, not to impose a formal specification process.

## Start from evidence

Read `PRODUCT.md`, the active issue, relevant `DESIGN.md` guidance, linked decisions, and available evidence. State what is unknown. Do not invent users, constraints, metrics, approval, research findings, or implementation details.

First decide whether this skill adds value. Use it for consequential ambiguity, a new or altered behavior boundary, material user harm on failure, or acceptance criteria that cannot yet be verified. For a clear, low-risk change, improve the issue directly and stop.

## Find the requirement risks

Check the issue for:

- vague or unobservable language such as “fast”, “simple”, or “scalable”;
- hidden assumptions, undefined terms, and missing ownership or boundaries;
- implementation bias that states a solution instead of the required outcome;
- missing unhappy paths, permissions, state transitions, or recovery behavior;
- acceptance criteria that cannot be observed or tested;
- relevant non-functional constraints: privacy, security, accessibility, reliability, performance, or compatibility.

Turn each material gap into a focused question, a measurable constraint, or an explicit assumption. Ask for a human decision when resolving the gap would materially alter scope, direction, risk, or cost.

## Structure only what helps

Draft the result for the active GitHub Issue. Apply it to the issue only with explicit approval. Add or improve, as relevant:

1. The intended outcome, user, and current scope.
2. Explicit non-goals, assumptions, dependencies, and open questions.
3. Observable acceptance criteria, including required error or edge behavior.
4. A measurable constraint when a non-functional requirement matters.
5. Links to the evidence and decisions that support the requirement.

Use EARS-style wording only when it clarifies conditional behavior:

- **Ubiquitous:** the system must always behave this way.
- **Event-driven:** when an event occurs, the system must respond this way.
- **State-driven:** while a state holds, the system must behave this way.
- **Optional:** when a feature or condition is enabled, the system must behave this way.
- **Unwanted:** if an unwanted condition occurs, the system must protect or recover this way.

Use Given/When/Then scenarios only for behavior where an example makes the criterion more testable. Cover both a representative success path and a material failure or edge path when that risk exists. Do not manufacture a fixed number of scenarios.

## Finish the requirement work

Summarize the clarified acceptance criteria, remaining uncertainty, and the next decision or implementation step. With approval, record the result in the issue. Update `PRODUCT.md`, `DESIGN.md`, or `docs/decisions/` only when the work creates durable product, experience, or contract guidance.

Do not create a parallel `spec.md`, phase handoff, or status file. Do not contact stakeholders, collect research, create external issues, or make other external changes without explicit approval.
