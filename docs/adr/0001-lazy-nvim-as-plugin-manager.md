# ADR 0001 — lazy.nvim as plugin manager

Status: accepted
Date: 2026-05-11

## Context

A Neovim config needs a plugin manager to declare, install, version-pin, lazy-load, and update plugins. Common choices: packer.nvim (archived), lazy.nvim, paq.nvim, vim-plug (legacy).

## Decision

Use `folke/lazy.nvim`. Bootstrap-clones itself from GitHub on first startup in `lua/config/lazy.lua` if not present. Single `lazy.setup()` call drives all plugin specs.

## Consequences

- **Plugin specs** are tables with conventional fields (`event`, `cmd`, `ft`, `keys`, `dependencies`, `opts`, `config`). This vocabulary leaks into the codebase and into ADRs/issues — see `CONTEXT.md`.
- **Lazy-loading by default**: plugins without an explicit `event`/`cmd`/`ft`/`keys` should still be lazy unless given `lazy = false`. Always specify a trigger.
- **Filetype packs** under `lua/plugins/extras/` are imported individually in `lua/config/lazy.lua` rather than auto-discovered. This is intentional: it makes the active language set explicit at the top level.
- **Lockfile** at `vim.fn.stdpath("data") .. "/lazy-lock.json"` is the source of truth for plugin versions.
- `lazy.nvim`'s `opts = function(_, opts)` chaining is the mechanism filetype packs use to extend the LSP server registry, treesitter parsers, and mason ensure-installed lists. Don't bypass it.

## Notes

`change_detection.enabled = true` is on — edits to plugin files trigger a reload notification. Set to false if it becomes noisy.
