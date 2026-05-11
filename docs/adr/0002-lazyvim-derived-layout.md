# ADR 0002 — LazyVim-derived layout, not LazyVim itself

Status: accepted
Date: 2026-05-11

## Context

LazyVim is a popular Neovim "distribution" that ships a curated set of plugins and conventions on top of `lazy.nvim`. The author of this config started from LazyVim, then extracted the parts they wanted rather than depending on the LazyVim runtime. The readme states this explicitly.

## Decision

Adopt LazyVim's **file layout and patterns** but not its runtime:

- `lua/config/` for bootstrap + options + keymaps + autocmds + colorscheme
- `lua/plugins/<group>.lua` for plugin groups, auto-loaded via `{ import = "plugins" }`
- `lua/plugins/extras/<language>.lua` for filetype packs, individually imported
- `opts = function(_, opts) vim.list_extend(...) end` as the extension pattern for cross-cutting plugin opts (treesitter parsers, mason ensure-installed, LSP servers)
- `_G.ByteVim` instead of `_G.LazyVim` as the global namespace for shared utilities
- `vim.uv` / `vim.fs` / `vim.lsp` APIs preferred over plugin-provided equivalents

## Consequences

- **Don't `require("lazyvim.util")`** — the runtime is not present. Equivalent helpers live in `lua/utils/`.
- **Don't add LazyVim's Extras dynamically** — they assume LazyVim's runtime. Filetype packs in this repo must be self-contained.
- **Patterns translate, names sometimes don't**: when a LazyVim doc references `LazyVim.lsp.on_attach`, that maps to `ByteVim.lsp.on_attach` here.

## Notes

If maintenance burden ever exceeds the value of forking, switching to LazyVim proper is a reasonable reversal. The cost is migrating `_G.ByteVim` callers and re-evaluating each plugin group against LazyVim's defaults.
