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
- misuse and cost: who may access or change what, abuse such as brute force or scraping, rate limits, and cost exposure from automated or paid API calls;
- data-protection behavior: minimization before data reaches a third party, retention, deletion, and export;
- acceptance criteria that cannot be observed or tested;
- relevant non-functional constraints: privacy, security, accessibility, reliability, performance, or compatibility.

Turn each material gap into a focused question, a measurable constraint, or an explicit assumption. Ask for a human decision when resolving the gap would materially alter scope, direction, risk, or cost.

## Ask in rounds

When a person must decide, ask in rounds rather than one question at a time. A round holds every open decision whose prerequisites are already settled. Number each question, give your recommended answer with a one-line reason, and word it so that "yes" accepts the recommendation. A question that depends on an answer from the same round waits for the next round. Find facts yourself from the code, the product context, and available tools; only decisions go to the person. Stop when nothing material is silently assumed, and confirm the shared understanding before acting on it.

## Slice work that is too big

When a requirement is too big for one focused session, or bundles several behaviors that could ship separately, split it into slices before refining each:

- Cut **vertical slices**: each one a narrow but complete path through every layer it needs (data, logic, interface, tests), demoable or verifiable on its own. Do not cut horizontal layers such as "all the database work" first.
- Size each slice to fit one fresh agent session, with its own observable acceptance criteria.
- Put enabling refactors first, so the later slices become simple: make the change easy, then make the easy change.
- Give each slice its **blocking edges**: the slices that must be finished before it can start. A slice without blockers can start at once.
- For a wide mechanical change across many call sites (renaming a field, retyping a shared value), use expand–contract instead: add the new form beside the old, migrate callers in batches, then remove the old form.
- Describe behavior and contracts, not file paths or line numbers; they go stale while a slice waits.

Present the slices as a numbered list with title, blockers, and what each delivers, and ask whether the granularity and the edges are right. With approval, create them on GitHub as sub-issues of the original issue, in dependency order, with native "blocked by" links.

## Keep the domain language

Read `GLOSSARY.md` in the product root when it exists. When a term in the issue or conversation conflicts with it, or a term is vague or overloaded ("account": customer or user?), say so immediately and propose the canonical term. When a product-specific term is settled, propose adding it to `GLOSSARY.md`, creating the file with its first term:

```markdown
**Order**:
A request by a **Customer** to buy one or more products.
_Avoid_: purchase, transaction
```

Keep each definition to one or two sentences about what the term is, bold other glossary terms, list rejected synonyms under `_Avoid_`, and leave out general programming concepts and implementation details. Group terms under subheadings only when clusters emerge.

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

When the issue is meant for the factory (`mode: factory` in `PRODUCT.md`), every acceptance criterion must be verifiable by an automated test through the product's public surface, because the factory's spec stage turns each one into a protected acceptance test and escalates any it cannot. Name the inputs, the observable result, and the relevant failure behavior; move criteria that need human judgment, such as visual quality, into a separate human-led issue.

Use Given/When/Then scenarios only for behavior where an example makes the criterion more testable. Cover both a representative success path and a material failure or edge path when that risk exists. Do not manufacture a fixed number of scenarios.

## Finish the requirement work

Summarize the clarified acceptance criteria, remaining uncertainty, and the next decision or implementation step. With approval, record the result in the issue. Update `PRODUCT.md`, `DESIGN.md`, or `docs/decisions/` only when the work creates durable product, experience, or contract guidance.

Do not create a parallel `spec.md`, phase handoff, or status file. Do not contact stakeholders, collect research, create external issues, or make other external changes without explicit approval.
