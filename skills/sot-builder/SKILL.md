---
name: sot-builder
description: >-
  Create or maintain a durable product decision or contract when it must outlive
  the current issue or pull request. The name is kept for compatibility with
  earlier kit versions; do not use it for status updates or routine notes.
---

# Durable decision record

The historical name “SoT builder” remains for compatibility. Records live in the product's `docs/decisions/`, not in a broad `docs/sot/` registry. This skill is optional: `kickoff` and `feature` already record durable decisions there when needed.

## When to create a record

Create one only if the choice needs to remain discoverable beyond the active issue or pull request, for example:

- a product rule with material impact;
- an architecture, data, privacy, security, or deployment boundary;
- an API or integration contract;
- a decision with a review or rollback trigger.

Do not create a record for routine status, temporary handoffs, small implementation notes, or a decision already fully explained in a short pull request.

## Process

1. Read the existing issue, pull request, `PRODUCT.md`, and related decisions.
2. Check whether a relevant record already exists; update or supersede it rather than duplicate it.
3. Copy the product's `docs/decisions/TEMPLATE.md` (installed from the kit's `templates/product/docs/decisions/`) to a new, numbered record in the same directory.
4. State the decision, evidence, alternatives, consequences, ownership, and the review or rollback trigger.
5. Link the decision to its issue or pull request and mark its status accurately.

Never invent evidence, approval, owners, or contracts. Ask for explicit approval when recording a consequential decision that has not already been made.
