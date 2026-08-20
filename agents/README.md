# Specialist agents

These are optional role briefs, not an obligatory relay race. The main conversation owns scope and cross-cutting decisions; delegate a specialist only when a bounded, independent question benefits from focused expertise, then bring the answer back into the main conversation for the decision.

Not installed by default. Add one with `scripts/install.sh --agent <name>` (Claude Code and OpenCode only — Codex has no native subagent directory, see [runtime adapters](../docs/runtime-adapters.md)), or copy the file manually per the [README](../README.md#manual-installation).

| Bounded question | Agent |
| --- | --- |
| Is this outcome, market, or pricing bet viable? | `business-strategist` |
| What should we build next, and why? | `product-manager` |
| Does the data support this direction? | `product-analyst` |
| What do users actually need here? | `ux-researcher` |
| Will this flow, UI, or accessibility decision hold up? | `product-designer` |
| Is this architecture, security, or data choice sound? | `tech-lead` |
| Implement this scoped, already-understood change | `developer` |
| Is this ready to release? | `qa-lead` |
| How do we message or launch this? | `product-marketing` |
| Will this affect onboarding or retention? | `customer-success` |
