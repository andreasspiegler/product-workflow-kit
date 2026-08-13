# V1 to V2 migration

V2 replaces the fixed seven-phase pipeline with risk-based orchestration. It preserves deliberate human gates, but removes mandatory handoffs, a global status file, and a design-tool chain that every product had to follow.

## Migration steps

1. Add the files from `templates/product/` to the target product and fill in `PRODUCT.md`.
2. Link or copy the selected V2 skills into the runtime's project-local skill directory.
3. Keep GitHub Issues and the project board for status; do not create `STATUS.md` or phase handoff files.
4. Move only still-relevant durable rules from `docs/sot/` into `docs/decisions/`; leave historical files in place with a deprecation note.
5. Replace a mandatory Nano Banana/v0 chain with an explicit design choice. Impeccable, image generation, and v0 are optional tools, not workflow phases.
6. Do not install the V1 session-start hook. It depends on `STATUS.md` and is intentionally not part of V2.

## Compatibility

The root `commands/` directory is retained only for V1 installations. V2 uses skills as the canonical workflow source. New installs should not copy those command files.
