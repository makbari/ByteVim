# ADR 0003 — `_G.ByteVim` as the cross-file utility namespace

Status: accepted
Date: 2026-05-11

## Context

Plugin specs in `lua/plugins/**` need shared helpers: LSP attach hooks, project-root detection, the keymap helper, the LSP keymap registration. The options:

1. Module-by-module `require("utils.lsp")` etc. at every call site
2. A single global `_G.ByteVim` populated lazily, callable as `ByteVim.lsp.on_attach(...)`
3. A small dependency-injection layer that passes utilities in

## Decision

Use **option 2**: a single global `_G.ByteVim`, assigned once in `lua/config/init.lua:1`:

```lua
_G.ByteVim = require("utils")
```

`lua/utils/init.lua` defines a metatable that lazily `require`s `utils.<key>` on first access and caches the result. Submodules become `ByteVim.lsp`, `ByteVim.path`, `ByteVim.utils`, `ByteVim.notes`, `ByteVim.lsp_keymaps`, `ByteVim.versions`.

## Consequences

- **Init order**: the `_G.ByteVim` assignment must run before any plugin spec is evaluated. This is why `lua/config/init.lua` requires `utils` first, before `options`/`lazy`/etc.
- **Plugin specs may reference `ByteVim.*` at top level** (e.g. `version = ByteVim.versions.lspconfig`). They are evaluated by lazy.nvim after the global is set.
- **Missing submodules error noisily**: the metatable in `lua/utils/init.lua:21` raises rather than returns nil. A typo in `ByteVim.lspkeymapss` will crash bootstrap. Live with this; it surfaces bugs early.
- **No new globals**: anything that wants to be reachable cross-file should be a submodule under `lua/utils/<name>.lua` and accessed via `ByteVim.<name>`. Don't pollute `_G`.

## Notes

This pattern is inherited from LazyVim's `_G.LazyVim` (see ADR-0002). Pure DI would be safer but the ergonomic cost across ~40 plugin specs isn't worth it for a personal config.

A future refinement (not adopted): switch the metatable to return a typed stub for unknown keys with a warning, so a typo degrades gracefully instead of crashing.
