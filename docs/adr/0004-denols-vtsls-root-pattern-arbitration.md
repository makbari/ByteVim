# ADR 0004 — Disambiguate `denols` vs `vtsls` by root pattern

Status: accepted
Date: 2026-05-11

## Context

The config installs both `denols` (Deno's LSP) and `vtsls` (TypeScript via the volar-style server) because the user works on both Deno projects and Node/TypeScript projects. Without arbitration, both would attach to the same TypeScript buffer and produce duplicate/conflicting diagnostics, completions, and code actions.

## Decision

Arbitrate by project root pattern at the lspconfig setup phase (`lua/plugins/lspconfig.lua`, around line 235):

- If the project root contains `deno.json`, `deno.jsonc`, or `import_map.json` → **disable `vtsls`**.
- Otherwise → **disable `denols`**.

Implemented via `ByteVim.lsp.disable(server, cond)` (`lua/utils/lsp.lua:100`), which hooks `on_new_config` and sets `config.enabled = false` when the predicate matches.

The `vtsls` and `denols` filetype packs in `lua/plugins/extras/` each also call `client.stop()` from `on_attach` as a belt-and-braces guard if `ByteVim.lsp.deno_config_exist()` returns true. This is redundant with the disable above but cheap.

## Consequences

- **Per-project, not per-buffer**: the decision is made once per LSP root, not re-evaluated when navigating between buffers. A monorepo containing both Deno and Node subprojects will get the wrong server in at least one of them. Acceptable.
- `angularls` uses the same disable pattern (`angular.json` / `project.json`) for symmetry — see the same block in `lspconfig.lua`.
- The `ByteVim.lsp.disable` API is the contract; the predicate is the implementation. Future extensions (e.g. `biome` vs `prettier` LSP) should follow this pattern.

## Notes

This is the canonical use case for `ByteVim.lsp.disable`. If only one TypeScript server is ever installed at a time, the whole arbitration block can be deleted.
