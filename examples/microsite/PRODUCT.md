---
workflow_kit:
  source: andreasspiegler/product-workflow-kit
  version: "a1b2c3d"
  installed_at: "2026-06-02"
---

# Product

## Outcome

Convert visitors from the newsletter and LinkedIn into registered attendees for the one-day "Systemic Thinking for Product Teams" workshop on 2026-09-18. Registered means: name, email, and dietary preference submitted; confirmation email received.

## User and context

Mid-level product managers and designers who already follow the newsletter. They decide to register within a single visit, on mobile most of the time, usually from a link in an email or LinkedIn post.

## Current scope

- One page: pitch, agenda, speaker bio, venue, price, and a signup form.
- Signup form posts to a form backend (no custom database) and triggers a confirmation email with the calendar file attached.
- A "sold out" state once the 40-seat cap is reached.

## Non-goals

- No account system or login.
- No CMS; content changes go through a code change and redeploy.
- No multi-language version. English only, matching the workshop.
- No payment processing at launch — invoicing happens manually after signup; add a payment provider only if a future workshop needs it.

## Constraints

- Must be live by 2026-08-20 to leave four weeks for promotion.
- Reuses the existing brand kit (colors, type, logo); no new visual identity work.
- Runs on existing static hosting; no new infrastructure.

## Success signal

40 confirmed signups by 2026-09-11 (one week before the workshop), with fewer than 5% of signups needing manual follow-up because the form failed silently. Baseline: 0, this is the first run of this workshop format. Owner: product owner, checked weekly from launch.

## Open questions

- Is a waitlist needed once the cap is hit, or does "sold out" simply stop signups? — Decided in [DEC-001](docs/decisions/DEC-001-no-account-system-or-waitlist.md).
- Does the confirmation email need a cancellation link, or is a reply-to address enough for the expected volume?
