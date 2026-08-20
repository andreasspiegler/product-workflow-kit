---
id: DEC-001
status: accepted
date: 2026-06-04
owners: [product-owner]
links:
  issue: "#3"
  pull_request: ""
---

# DEC-001: No account system, no waitlist

## Decision

Signups are anonymous, single-submission form entries. There is no login, no account, and no waitlist. Once the 40-seat cap is reached, the form switches to a static "sold out" state; no further data is collected for this workshop run.

## Context and evidence

Expected volume is under 50 signups total; a waitlist or account system would add build time and an ongoing support surface (password resets, duplicate accounts, waitlist promotion) that outweighs the benefit for a single low-stakes event.

## Alternatives considered

- Full account system with login: rejected, no repeat-visit use case exists yet to justify it.
- Waitlist with automatic promotion on cancellation: rejected for this run; cancellations can be handled manually by email at this volume.

## Consequences

- Manual follow-up (refund, swap) goes through the organizer's inbox, not the product.
- If a second workshop is planned, revisit this decision before assuming the same scope — repeat events are the trigger to reconsider accounts and waitlists.
