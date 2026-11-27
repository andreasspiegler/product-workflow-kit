---
workflow_kit:
  source: andreasspiegler/product-workflow-kit
  version: "{{WORKFLOW_KIT_VERSION}}"
  installed_at: "{{DATE}}"
---

# Product

## Outcome

<!-- What change for whom should this product create? -->

## User and context

<!-- Primary user, situation, and job to be done. Link research rather than copying it. -->

## Current scope

<!-- The smallest meaningful current scope. -->

## Non-goals

<!-- Explicitly excluded work and assumptions that are still unproven. -->

## Constraints

<!-- Time, technical, legal, privacy, business, or team constraints. -->

## Data and privacy

<!-- Personal or sensitive data the product processes; which processors or AI providers receive which data; minimization before sharing; retention, deletion, and export; data processing agreements and privacy notices. Write `No personal data.` if none. -->

## Environments

<!-- Local, staging, and production setup; where secrets live and who can access them; who may deploy; how deployments exclude internal workflow files (see `AGENTS.md`). -->

## Agent isolation

<!-- How strongly coding agents are isolated while working on this product: `none`, `agent` (Claude Code sandbox and deny rules in `.claude/settings.json`), or `container` (Dev Container in `.devcontainer/` plus the agent sandbox). Record the level, the reason, the date, which runtimes it covers, and any private directories added to the deny lists. Weakening it needs explicit approval. -->

{{AGENT_ISOLATION}}

## Operating mode

<!-- Who resolves the human gates in day-to-day work. `human-led`: a person decides at every gate (default). `factory`: issues labelled `factory:ready` are specified, built, verified, reviewed, and merged by `.github/workflows/factory.yml` without a human, up to `autonomy_ceiling` (`nano`, `micro`, or `standard`); `merge` is `auto` or `pr-only`; `deploy` is `staging-auto` or `human`. Production deployment always stays human. Keep the four keys on their own lines; the factory workflow reads them. Record the reason and date. Changing the mode or raising the ceiling needs explicit approval. -->

{{OPERATING_MODE}}

## Optional tools

<!-- Record only deliberately enabled optional tools. For each: name, source and version or commit, runtime path (or service access point), and approval. For an unversioned service, record the documentation checked and date instead of inventing a version. Write `None enabled.` if there are none. -->

## Success signal

<!-- Observable behavior or metric, baseline if known, measurement window, and owner. -->

## Open questions

<!-- Questions that could change direction or scope. -->
