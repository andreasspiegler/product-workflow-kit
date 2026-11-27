# Coding standards

Read when reviewing a change, by a person or by an automated review. Implementation follows the existing code and conventions; review checks the result against these rules.

Keep only judgement calls here: rules that need a reader to decide, such as consistency across files or matching the surrounding style. A mechanical rule (a banned API, an import shape, a file-location rule, a naming pattern) belongs in an automated check instead: a lint rule, a test, or a CI job. When a review catches the same mechanical problem twice, add the check and remove the written rule.

Each rule says what to do, why, and how to recognize a violation. Remove rules that no longer change what anyone does.

## Rules

<!-- Example:
**Errors reach the user in their language.** User-facing error messages name what happened and what the user can do next, never a stack trace or internal code. Violation: a raw exception message or error code shown in the UI.
-->
