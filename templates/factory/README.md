# Factory mode

This product runs in factory mode: issues labelled `factory:ready` are specified, built, verified, reviewed, merged, and optionally deployed to staging without a human in the loop, up to the autonomy ceiling recorded under "Operating mode" in `PRODUCT.md`. Everything above the ceiling, and every gate listed in the `factory-run` skill, comes back labelled `factory:needs-human`.

Installed by `scripts/add-factory.sh` from the Product Workflow Kit. Everything in `.factory/` and `.github/` is a protected path: the factory's verify stage rejects any pull request that changes it. Change these files only by hand.

## How a run works

| Stage | Who | What | Protection |
| --- | --- | --- | --- |
| spec | Claude | Triage against the ceiling; write one failing acceptance test per criterion under `tests/acceptance/`; or escalate. | The workflow reads the ceiling before Claude runs; only new files under `tests/acceptance/` are accepted. |
| build | Claude | Implement the smallest correct change; open a pull request with a verification record. | Cannot edit `tests/acceptance/`; cannot merge or force-push. |
| verify | Workflow | Acceptance tests unchanged since spec; no protected paths or dependency manifests changed; `.factory/setup.sh` and `.factory/check.sh` pass fresh. | Deterministic; read-only token; no secrets. |
| review | Claude, fresh context | Independent review against the issue and the kit's quality rules; one pull request comment. | Cannot edit, commit, push, or merge. |
| merge | Workflow | Waits for the product's own CI, squash-merges exactly the verified commit, and starts the staging deployment by policy. | Deterministic; `--match-head-commit`. |

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
4. **Checks.** Make `.factory/setup.sh` install the toolchain and dependencies, and `.factory/check.sh` run every test including `tests/acceptance/`. Both must exit non-zero on failure.
5. **Staging (optional).** For `deploy: staging-auto`, give your staging deployment workflow a `workflow_dispatch` trigger and set the repository variable `FACTORY_STAGING_WORKFLOW` to its file name, for example `deploy-staging.yml`. A merge made with the workflow token does not trigger `push` workflows, so the factory starts it explicitly.
6. **Production.** Keep production behind a GitHub Environment with required reviewers. The factory never deploys to production.
7. **Branch protection (recommended).** Require your CI checks on the default branch. Do not require a human approval if `merge: auto` should work; use `merge: pr-only` instead.

Optional repository variables: `FACTORY_MODEL`, `FACTORY_MAX_TURNS_SPEC` (default 40), `FACTORY_MAX_TURNS_BUILD` (80), `FACTORY_MAX_TURNS_REVIEW` (40), and `FACTORY_PROTECTED_REGEX` for additional protected paths as an extended regular expression.

## Using it

Write the issue with observable acceptance criteria (the `requirements-quality` skill helps), then add `factory:ready`. One run per issue at a time; label several issues only when they do not touch the same files, otherwise a later merge conflicts and comes back as `factory:needs-human`. To retry after clarifying an issue, delete any leftover `factory/issue-<n>` branch and add `factory:ready` again.

Use the factory in private repositories, or where only trusted people write issues and comments: issue text reaches Claude as input.

## Known limits

- The acceptance tests are fixed before implementation and protected from change, but the build stage can read them. They are a contract, not a hidden holdout set; the independent review checks for implementations that only satisfy the tests.
- The Claude Code sandbox on the runner needs `bubblewrap` and `socat`, which the workflow installs. If it cannot start, the run fails and the issue is escalated; check the first run's log.
- The factory decides only as well as the acceptance criteria and checks allow. Outcome learning after release stays with a human.
