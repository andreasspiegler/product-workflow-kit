---
status: accepted
---

# Design direction

This is a living, concise record of the product's interaction and visual decisions. It is not a substitute for the issue-level acceptance criteria.

## Primary journey

Visitor arrives from an email or LinkedIn link → reads the pitch and agenda → scrolls to the signup form → submits name, email, dietary preference → sees a confirmation screen and receives a confirmation email with the calendar file. Success is a completed form submission, not a page view.

## Experience principles

- One page, one decision: nothing here competes with "sign up." No secondary navigation, no unrelated links out.
- Mobile first: most traffic arrives from a phone via a social link; the form must be usable one-handed above the fold on scroll.
- Honest scarcity: the seat count is real and updates from actual signups, not a manufactured countdown.

## System and patterns

Reuses the existing brand kit: type scale, color tokens, and header/footer components. No new components beyond the signup form and the sold-out state.

## Required states

- Empty: page before any signups shows the full 40-seat count.
- Loading: form shows a disabled submit button with a spinner during submission.
- Error: failed submission keeps the entered data and shows a retry message with a mailto fallback.
- Sold out: form is replaced by a static message once 40 signups are confirmed; no further submissions accepted.
- Mobile/responsive: single column below 768px; form fields stack full-width.

## Evidence and decisions

- Seat cap and no-waitlist decision: [DEC-001](docs/decisions/DEC-001-no-account-system-or-waitlist.md).

## Open design questions

- Should the sold-out state offer an email signup for "notify me if a spot opens"? Needs a decision before implementation if scope grows.
