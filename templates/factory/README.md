# Factory mode

This product runs in factory mode: issues labelled `factory:ready` are specified, built, verified, reviewed, merged, and optionally deployed to staging without a human in the loop, up to the autonomy ceiling recorded under "Operating mode" in `PRODUCT.md`. Everything above the ceiling, and every gate listed in the `factory-run` skill, comes back labelled `factory:needs-human`.

Installed by `scripts/add-factory.sh` from the Product Workflow Kit. Everything in `.factory/` and `.github/` is a protected path: the factory's verify stage rejects any pull request that changes it. Change these files only by hand.

## How a run works

| Stage | Who | What | Protection |
| --- | --- | --- | --- |
| route | Workflow | Starts on `factory:ready`, on an answer to a factory question, or on a rework round the factory dispatched itself. | Answers count only from people with write access. |
| spec | Claude | Triage against the ceiling; write visible acceptance tests under `tests/acceptance/` and hidden tests under `tests/holdout/`; or stop with a question and options. | The workflow reads the ceiling before Claude runs; only new files under `tests/acceptance/` may be pushed; hidden tests leave the run only as an artifact. |
| build | Claude | Implement the smallest correct change; open or, in a rework round, update the pull request with a verification record, assumptions, and a confidence line. | Never sees the hidden tests; cannot edit `tests/acceptance/`, read issues or comments directly, merge, or force-push. |
| verify | Workflow | Acceptance tests unchanged since spec; no protected paths or dependency manifests changed; `.factory/setup.sh` and `.factory/check.sh` pass fresh, first without and then with the hidden tests. | Deterministic; read-only token; no secrets. |
| review | Claude, fresh context | Independent review against the issue, the diff, and both test sets; findings go to the pull request. | No shell, no edits, no GitHub access. |
| merge | Workflow | Waits for the product's own CI, squash-merges exactly the verified commit, and starts the staging deployment by policy. | Deterministic; `--match-head-commit`. |
| report | Workflow | Labels and comments the outcome. A failed verify or review starts a rework round (up to `FACTORY_MAX_REWORKS`, default 2) before the issue comes back to you. | Deterministic. |

Every agent reads the issue through `.factory/context.sh`: the issue, comments from people with write access, and the factory's own comments. Other comments are left out.

## One-time setup

Do these by hand; the kit never changes remote configuration.

1. **Claude GitHub App.** Install it on the repository (`claude` → `/install-github-app`, or https://github.com/apps/claude). Its token lets factory pull requests trigger your CI; pull requests opened with the default workflow token would not.
2. **Credentials.** Add the repository secret `ANTHROPIC_API_KEY`, or `CLAUDE_CODE_OAUTH_TOKEN` from `claude setup-token` for a subscription.
3. **Labels.**
   ```bash
   gh label create factory:ready --color 0E8A16 --description "Hand this issue to the factory"
   gh label create factory:running --color FBCA04 --description "The factory is working on it"
   gh label create factory:needs-human --color D93F0B --description "The factory stopped and needs a decision"
   gh label create factory:human-review --color 1D76DB --description "Verified and reviewed; waiting for a human merge"
   gh label create factory:merged --color 5319E7 --description "Merged by the factory"
   ```
4. **Checks.** Make `.factory/setup.sh` install the toolchain and dependencies, and `.factory/check.sh` run every test including `tests/acceptance/` and `tests/holdout/`, which the factory adds only during verification. Both must exit non-zero on failure.
5. **Staging (optional).** For `deploy: staging-auto`, give your staging deployment workflow a `workflow_dispatch` trigger and set the repository variable `FACTORY_STAGING_WORKFLOW` to its file name, for example `deploy-staging.yml`. A merge made with the workflow token does not trigger `push` workflows, so the factory starts it explicitly.
6. **Production.** Keep production behind a GitHub Environment with required reviewers. The factory never deploys to production.
7. **Branch protection (recommended).** Require your CI checks on the default branch. Do not require a human approval if `merge: auto` should work; use `merge: pr-only` instead.

Optional repository variables: `FACTORY_MAX_REWORKS` (default 2), `FACTORY_MODEL`, `FACTORY_MAX_TURNS_SPEC` (default 40), `FACTORY_MAX_TURNS_BUILD` (80), `FACTORY_MAX_TURNS_REVIEW` (40), and `FACTORY_PROTECTED_REGEX` for additional protected paths as an extended regular expression.

## Using it

Write the issue with observable acceptance criteria (the `requirements-quality` skill helps), then add `factory:ready`. One run per issue at a time; label several issues only when they do not touch the same files, otherwise a later merge conflicts and comes back as `factory:needs-human`.

When the factory stops with a question, it comments the decision it needs, two or three options, and a recommendation. Answer in a comment on the issue; the factory closes any open factory pull request and starts again from the spec stage, with your answer as binding context. Comments from people without write access never start a run and never reach the agents. For other stops, clarify the issue, delete any leftover `factory/issue-<n>` branch, and add `factory:ready` again.

Use the factory in private repositories, or where you trust the people who write issues: the issue body reaches the agents as input.

## Known limits

- The hidden tests are written by the same spec stage as the visible ones and cover only what the acceptance criteria state. They make tailoring to the visible tests fail; they do not find requirements nobody wrote down.
- When the hidden tests fail, the rework comment includes the end of the test output, so a rework round learns what failed. Keep `FACTORY_MAX_REWORKS` low.
- Anyone with read access to the repository can download the hidden tests from the run's artifacts; they are hidden from the build agent, not from people.
- The Claude Code sandbox on the runner needs `bubblewrap` and `socat` and, on Ubuntu 24.04 and later, relaxed AppArmor user-namespace rules. The workflow installs and relaxes these on the disposable runner VM. If the sandbox still cannot start, Claude cannot run any command and stops; check that run's log.
- The factory decides only as well as the acceptance criteria and checks allow. Outcome learning after release stays with a person.
