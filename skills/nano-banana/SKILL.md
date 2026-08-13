---
name: nano-banana
description: >-
  Optionally generate or edit exploratory visual assets with the Nano Banana
  extension when that tool is available and explicitly appropriate. Do not use
  as the mandatory image-generation path or a required product-design phase.
---

# Nano Banana: optional visual exploration

Use this skill only when an image exploration or image edit would materially help the task and the target runtime has the Nano Banana extension configured. It is an optional tool, not a default or a replacement for product design, diagrams, accessible UI, or implementation review.

## Before use

1. Confirm the purpose: concept exploration, a prototype, a non-production asset, or an approved production asset.
2. Confirm that the user has authorized the tool, any associated cost, and use of referenced images or brand material.
3. Check the current runtime's approved image-generation capability first. Do not require users to install Gemini or provide credentials if another approved capability is available.
4. Keep output in the project, explain what it is for, and verify source, licensing, accessibility, and design fit before using it in a product.

## Safe operation

Follow the installed extension's documented commands and permission model. Never use blanket auto-approval flags such as `--yolo`. Do not load, print, commit, or share API keys, tokens, or `.env` contents.

Generate the minimum number of variants needed for a concrete decision. For UI concepts, treat outputs as references only: document the chosen interaction and visual rules in `DESIGN.md`, and implement them with the product's actual components and accessibility requirements.

## When not to use it

- A structured diagram, wireframe, or table communicates the idea more clearly.
- The request needs a production UI decision but no user journey or system context exists yet.
- The image would introduce licensing, privacy, identity, or brand risks that have not been cleared.
- The runtime does not have a safe, authorized configuration.
