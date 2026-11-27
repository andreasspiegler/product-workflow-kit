---
name: retro
description: >-
  Run a retrospective on finished work to improve how agents work on this
  product: instructions, automated checks, coding standards, glossary, and
  context. Use after a merged change, a difficult session, or repeated review
  findings; also used headless by the factory's retro run. Not for judging the
  product outcome, which `quality-release` covers.
---

# Retro

A retro improves the **environment** agents work in, so the next change goes better: what they read, which checks catch their mistakes, and which rules the review enforces. It does not judge whether the product change achieved its outcome; that is the outcome check in `quality-release`.

## 1. Gather the evidence

Read the primary sources for the work the person names, or the current session when they name none:

- the conversation or session, including dead ends, retries, and corrections the person had to make;
- the pull requests, their review comments (human and automated), and failed CI runs;
- the issues, including questions asked and how they were answered;
- the current `AGENTS.md`, `CODING_STANDARDS.md`, `GLOSSARY.md`, the product's check commands and CI workflows, and the skills involved.

State what you could not read. Do not reconstruct a session from memory.

## 2. Find candidates

Look for these, each with the signal that points to it:

| Category | Signal | Typical change |
| --- | --- | --- |
| **Automated checks** | An agent made a mistake a deterministic check could catch, or the repository has no guardrail running lint, types, and tests. | Wire up an existing check that is unused or broken first; otherwise add a lint rule, test, or CI job. |
| **Coding standards** | Review missed a problem, or flagged the same judgement-call problem repeatedly. | Add, sharpen, or remove a rule in `CODING_STANDARDS.md`. |
| **Domain language** | People or agents used different words for the same thing, or one word for different things. | Add or sharpen a term in `GLOSSARY.md`. |
| **Navigation** | An agent took long to find a file, a contract, or a hidden dependency. | Add a short pointer in `AGENTS.md` or a doc that names where it lives and when to read it. |
| **Instruction load** | `AGENTS.md` or a skill is long, repeats itself, or holds rules that never change behavior. | Move rules into checks or `CODING_STANDARDS.md`; delete no-ops. |
| **Information access** | A crucial fact (logs, data shape, a third-party contract) was not available to the agent. | Name the source and how to reach it read-only. |
| **Tool economy** | An agent made slow or expensive tool calls that a narrower command or script would avoid. | Document or add the narrower path. |
| **Product context** | Work stalled on something `PRODUCT.md`, `DESIGN.md`, or `docs/decisions/` should have answered. | Propose the missing context for the owner to decide. |

Classify every rule-shaped finding first. A **mechanical** problem (a banned API, an import shape, a naming or file-location rule, a fixed syntactic pattern) gets a deterministic check; do not write a rule an automated check could enforce. Keep `CODING_STANDARDS.md` for **judgement calls** that need a reader. Standards belong to review: the implementing agent carries the most context, the reviewer the least, so the reviewer enforces them.

## 3. Keep only what the evidence carries

- Each proposal cites concrete evidence: the pull request, comment, failed run, or session moment.
- A pattern needs at least two occurrences. A single occurrence counts only when its cost was high, and you say so.
- Propose at most three changes, ordered by expected effect. Fewer, sharper changes beat a long list.
- Never propose weakening a human gate, the agent isolation, a protected path, or the operating mode's ceiling as an environment fix. If evidence suggests one of these is miscalibrated, report it as a decision for the person, with the evidence.

## 4. Present and apply

For each proposal, state:

1. **Observation:** what happened, with links.
2. **Change:** the file and the exact addition, edit, or removal.
3. **Expected effect:** what should go better.
4. **How to tell:** the signal that shows whether it worked, for example fewer review findings of that kind or no further retries on that step.

Apply changes only with explicit approval, through the product's normal review path. When nothing meets the evidence bar, say so and stop; an empty retro is a valid result.
