---
name: quality-release
description: >-
  Plan and perform proportionate verification for a product change or release.
  Use for acceptance criteria, test strategy, regression risk, accessibility,
  release readiness, rollout, and post-launch checks.
---

# Quality and release

Quality is selected by risk, not skipped because a change is small or an agent calls it a `nano` task.

## Start with a risk scan

Read the issue or pull request, relevant product context, and the changed code. State the risk level and why, considering:

- product impact and uncertainty;
- data integrity, privacy, security, and authorization;
- reliability, performance, and integrations;
- user experience, accessibility, and supported devices;
- blast radius, reversibility, rollout, and observability.

Then choose the smallest verification set that gives credible evidence. A low-risk copy change may need only a visual check; an authentication, payment, migration, or data change requires much stronger evidence.

## Verification record

For each meaningful change, make the following visible in the issue or pull request:

1. Acceptance criteria and expected behavior.
2. Checks performed, their result, and coverage limits.
3. Important edge, error, and regression scenarios.
4. Known risks, deferred work, and rollback or mitigation path.
5. For a release, the release gate and the post-launch signal.

Use automated tests where they protect repeatable behavior. Add focused manual checks for visual, interaction, accessibility, and environment-specific behavior that tests do not cover.

## Use test-first selectively

Choose a test-first loop when the expected behavior is stable enough to describe before implementation and an executable test would reduce meaningful risk. It is especially useful for business rules, data transformations, authorization, API contracts, bug regressions, state transitions, and other deterministic behavior.

Do not require it for exploratory work, visual or copy changes, a still-unclear product decision, or behavior that can only be assessed credibly in the real interface or environment.

When test-first is appropriate:

1. Make the relevant acceptance criterion observable and agree on the intended behavior.
2. Let the developer, QA lead, or tech lead create a focused failing test that demonstrates the intended behavior and fails for the expected reason.
3. Implement the smallest change that makes the test pass, then refactor without changing the agreed behavior.
4. Run the proportionate regression and manual checks that the test cannot replace.

Treat a passing test as evidence, not as proof that the whole product change is ready. Keep the acceptance criteria, test evidence, and remaining limits visible in the issue or pull request.

## Release and outcome

Do not treat a merge or deployment as completion. Before release, confirm the target environment, rollback path, monitoring or logs, and required approval. Do not deploy or change production systems without explicit authorization.

For changes with product impact, write the outcome check: signal, baseline if available, measurement window, owner, and the decision that the result will inform (iterate, scale, stop, or investigate).
