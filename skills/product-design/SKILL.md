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

## Find references when direction needs evidence

For a new surface, a redesign, or an unresolved visual or interaction direction, actively seek relevant references before proposing options. Revisit the search when the audience, journey, or direction materially changes, or a review exposes a specific gap. A routine change within an established system does not need a new search.

Choose sources for the question:

| Source | Useful for |
| --- | --- |
| [Dribbble](https://dribbble.com/) | Visual directions, typography, composition, and interface details. |
| [Awwwards](https://www.awwwards.com/) | Live websites, distinctive art direction, storytelling, and interaction. |
| [Mobbin](https://mobbin.com/) | Screens, states, and connected user flows from real products. |
| [Lummi](https://www.lummi.ai/) | Image direction, illustrations, and visual assets. |

Use the smallest useful set, normally three to five references; do not browse every portal by default. For each, link the specific example and state its relevance, the principle worth adapting, and what does not fit this product. Inspect the live flow where interaction matters; a screenshot or award is not usability evidence. Existing product and brand constraints still take precedence.

Use available, authorized access. If a reference requires an unavailable account or paid access, state the limitation and use accessible evidence or supplied references; do not invent observations. Check usage rights before incorporating an asset. Keep slice-specific references in the issue or pull request and only enduring influences in `DESIGN.md`.

## Triage motion and 3D when they are in scope

Do not add motion or 3D by default. When a change introduces or alters either, decide first whether it earns its place:

- frequency: keep keyboard-initiated and high-frequency actions instant; make frequent interaction motion near-imperceptible;
- purpose: name the intended benefit — feedback, spatial consistency, state indication, preventing a jarring change, explanation, product exploration, brand expression, or rare delight;
- context: decorative motion does not belong on functional or information-dense UI, and motion must fit the product's established personality.

Choose implementation after agreeing on the intended effect. Reuse suitable product capabilities and native CSS or browser APIs first. Consider [GSAP](https://gsap.com/docs/v3/) for coordinated timelines, scroll-driven storytelling, or complex SVG animation. Consider [Three.js](https://threejs.org/) for interactive product views, spatial explanations, or a defining 3D scene. Neither library is a default dependency, and a 3D image or video may be sufficient when live interaction adds no value.

For a consequential choice, compare the simpler alternative, intended benefit, mobile performance and asset budget, accessibility, maintenance cost, and fallback behavior. Prototype the uncertain effect before committing to a large implementation. Check current documentation and licensing for the chosen version, and obtain approval before adding a dependency. Keep the decision in the issue or, if it outlives the slice, `docs/decisions/`; record reusable motion and 3D rules in `DESIGN.md`. Verify the result with `quality-release`.

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
- `audit` after implementation, when accessibility, responsive behavior, or technical quality needs additional evidence;
- `document` when stable design-system decisions should be captured in `DESIGN.md`.

For other focused risks, use the matching available activity (for example `adapt` for device-fit or `harden` for error, i18n, and edge-state readiness). Do not offer Impeccable for implementation-only changes or routine fixes with no meaningful experience risk.

Use [Impeccable](https://impeccable.style/) only when it is installed in the target runtime and recorded in `PRODUCT.md`. Its output is evidence, not approval. An offer is not approval to install it. Do not install plugins or hooks globally. Keep any hook or provider configuration project-local and opt-in.

## Optional web-interface review

The Vercel `web-design-guidelines` skill is a focused code review after a web interface has been implemented. Offer it when changed UI code has material risk around interaction, keyboard or focus behavior, forms, async states, responsive layout, motion, semantic markup, or browser performance. Do not offer it for a static low-risk copy or styling adjustment without such a risk.

It is distinct from Impeccable: Impeccable helps choose or assess an experience and its visual direction; this review checks implementation details in the changed UI code. Both can be useful when the risks are separate.

Only use the skill when it was deliberately installed project-locally from a reviewed, pinned source and explicitly approved for the task. Its findings are follow-ups to assess against the product's established system and language, not a design direction or release approval. Apply the detailed verification and recording rules in `quality-release`.

## Optional visual tools

Image generation and v0 can be useful for exploration or rapid prototypes, but neither is a required production path. Use them only after choosing the purpose, handling source and licensing constraints, and deciding how the resulting artifact will be validated. The code owner remains responsible for maintainable, accessible implementation.

### Claude Design

Explicitly offer [Claude Design](https://support.claude.com/en/articles/14604397-set-up-your-design-system-in-claude-design) when a new design system, consolidation of inconsistent styling, or comparison of materially different prototypes would benefit from it. State the intended gain; it is an optional authoring tool, distinct from reference discovery and design review.

Use it only when available and authorized for the task, and record enabled use in `PRODUCT.md`. Confirm which assets or code may be shared under the product's data and privacy constraints. Do not assume a subscription, connector, or Claude Code runtime; a manual brief and artifact handoff can work with Codex or OpenCode too.

Provide a compact brief: product outcome, audience and main journey, existing components and brand assets, selected references with rationale, necessary states, and accessibility and implementation constraints. Start from the existing system when one exists. Treat generated tokens, components, and prototypes as proposals to review for brand fit, consistency, required states, accessibility, and feasibility in the actual stack.

Carry accepted reusable rules into `DESIGN.md` and the product's actual tokens and components; keep exploration links and slice-specific details in the issue or pull request. Generated output does not replace implementation verification. If the tool is unavailable or declined, continue with the same brief and the available local design workflow. Creating an exploration does not authorize publishing or sharing it externally.

## Deliverable

Return the smallest useful design record:

- a clear journey or interaction specification;
- necessary states and accessibility constraints;
- links to evidence or explorations;
- decisions needed from the user and their consequences;
- explicit verification criteria for the implemented result.

Update `DESIGN.md` only for reusable or durable direction. Keep ticket-specific details in the issue or pull request.
