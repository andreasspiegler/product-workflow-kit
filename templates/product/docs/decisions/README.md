# Durable decisions

Store a note here only when a decision, rule, or contract must outlive its issue or pull request: for example a security boundary, API contract, data-retention rule, architecture choice, or an intentionally stable product rule.

Before writing one, check all three:

1. **Hard to reverse:** changing your mind later has a meaningful cost.
2. **Surprising without context:** a future reader would ask why it was done this way.
3. **A real trade-off:** there were genuine alternatives, and this one was chosen for stated reasons.

If any is missing, the pull request or issue is the better place.

Do not use this directory for status updates, transient handoffs, routine implementation notes, or decisions already clear in a short pull request. Use [TEMPLATE.md](TEMPLATE.md) and link the related issue or pull request.
