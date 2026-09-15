---
name: product-design
description: >-
  Shape, document, and review product experience work when a change has a
  meaningful UI, interaction, content, or accessibility risk. Use for user
  flows, interface direction, design systems, usability review, and design
  handoff. It is not required for implementation-only changes.
---

# Product design

Use this skill to reduce a real experience risk, not to create design artifacts by default. For a bounded question that benefits from a dedicated specialist, delegate to `product-designer` or, for user evidence, `ux-researcher` — see [`agents/README.md`](../../agents/README.md).

## Start with context

Read `PRODUCT.md`, the relevant issue or pull request, and `DESIGN.md` if it exists. Read the current product before proposing a new pattern. If any of these are missing, state the gap and create only the smallest context necessary with the user's approval.

Identify:

- the user, their job, and the success moment;
- the important journey and its highest-risk step;
- existing components, tokens, content style, and interaction patterns;
- required states: empty, loading, error, permissions, responsive, keyboard, and assistive technology where relevant;
- the decision that needs evidence or human approval.

## Make a design read

Before proposing a direction or writing UI code, state one concise design read: the surface or journey, its user, the intended or established interaction and visual language, and the existing system or pattern it should lean on. Base it on the product context, the running interface, brand assets, and supplied references; existing product truth wins over generic aesthetic preference.

If the available evidence would support materially different directions, ask one decision-oriented question. Otherwise state the read and continue. Do not invent an audience, brand tone, design system, or reference.

## Triage motion when it is in scope

Do not add motion by default. When a change introduces or alters it, decide first whether it earns its place:

- frequency: keep keyboard-initiated and high-frequency actions instant; make frequent interaction motion near-imperceptible;
- purpose: name the user benefit — feedback, spatial consistency, state indication, preventing a jarring change, explanation, or rare delight;
- context: decorative motion does not belong on functional or information-dense UI, and motion must fit the product's established personality.

For a dedicated motion task, use one of these only when it has been deliberately installed project-locally from a reviewed, pinned source:

- `animate` to implement a motion decision that passed this triage;
- `review-animations` to critique changed motion before release;
- `find-animation-opportunities` to identify a short, high-conviction list when an interface feels static;
- `prototype` to compare genuinely different UI directions before a consequential choice.

These are optional, explicit aids. Do not install them globally or make their use a mandatory design phase.

## Choose the lightest useful design activity

| Situation | Appropriate activity |
| --- | --- |
| Existing pattern, low UI risk | Specify the change in the issue and verify it in the implemented interface. |
| New or altered journey | Map the main flow and states before coding. |
| Consequential visual or interaction direction | Present a small number of concrete options and ask for a decision. Each option must differ along a named axis, such as hierarchy, density, interaction model, or motion character, and name its trade-off; color or copy variations alone are not separate directions. |
| Existing experience may be weak | Audit the journey against usability and accessibility risks. |
| Repeated UI work | Document only the reusable rules and components in `DESIGN.md`. |

Do not turn a ticket into a mandatory wireframe, image-generation, or v0 exercise.

## Impeccable integration

During design triage for a user-facing UI or interaction change with meaningful experience risk, explicitly offer the single most fitting Impeccable activity as an option and state its intended gain. If it would not reduce a real risk, state why it is not needed. This is a decision cue, not a default step: do not install or invoke Impeccable without explicit approval.

Choose the activity from the moment in the work:

- `shape` before implementation, when a new journey or visual/interactions direction needs to become concrete;
- `critique` when an existing experience needs a diagnosis before deciding what to change;
- `clarify` when labels, calls to action, instructions, or error messages create comprehension risk;
- `distill` when a surface or journey is overloaded and reducing complexity is the central design goal;
- `polish` after behavior and content are stable, when a bounded final refinement would improve a UI review or release;
- `audit` after implementation, when accessibility, responsive behavior, or technical quality needs additional evidence.

For other focused risks, use the matching available activity (for example `adapt` for device-fit or `harden` for error, i18n, and edge-state readiness). Do not offer Impeccable for implementation-only changes or routine fixes with no meaningful experience risk.

When the [Impeccable](https://impeccable.style/) skill is installed in the target runtime, use it as an optional design-quality aid:

- `shape` to explore a user-facing direction before implementation;
- `document` to capture stable design-system decisions in `DESIGN.md`;
- `clarify` to improve potentially confusing UX copy and feedback;
- `distill` to remove unnecessary complexity from a surface or journey;
- `polish` before a UI pull request when visual refinement is valuable;
- `audit` as additional evidence for usability, visual, or accessibility review.

Its output is evidence, not approval. An offer is not approval to install it. Do not install plugins or hooks globally. Keep any hook or provider configuration project-local and opt-in.

## Optional web-interface review

The Vercel `web-design-guidelines` skill is a focused code review after a web interface has been implemented. Offer it when changed UI code has material risk around interaction, keyboard or focus behavior, forms, async states, responsive layout, motion, semantic markup, or browser performance. Do not offer it for a static low-risk copy or styling adjustment without such a risk.

It is distinct from Impeccable: Impeccable helps choose or assess an experience and its visual direction; this review checks implementation details in the changed UI code. Both can be useful when the risks are separate.

Only use the skill when it was deliberately installed project-locally from a reviewed, pinned source and explicitly approved for the task. Its findings are follow-ups to assess against the product's established system and language, not a design direction or release approval. Apply the detailed verification and recording rules in `quality-release`.

## Optional visual tools

Image generation and v0 can be useful for exploration or rapid prototypes, but neither is a required production path. Use them only after choosing the purpose, handling source and licensing constraints, and deciding how the resulting artifact will be validated. The code owner remains responsible for maintainable, accessible implementation.

## Deliverable

Return the smallest useful design record:

- a clear journey or interaction specification;
- necessary states and accessibility constraints;
- links to evidence or explorations;
- decisions needed from the user and their consequences;
- explicit verification criteria for the implemented result.

Update `DESIGN.md` only for reusable or durable direction. Keep ticket-specific details in the issue or pull request.
