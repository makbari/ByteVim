# 06 — Delete dead and half-broken filetype packs

Status: ready-for-agent

## Files

- `lua/plugins/extras/python.lua` — **delete**
- `lua/plugins/extras/lua.lua` — **delete**
- `lua/plugins/extras/html.lua` — **complete or delete** (decision below)
- `lua/plugins/extras/vue.lua` — **decide**: uncomment in `lazy.lua:34` or delete the file
- `lua/plugins/extras/ruby.lua` — **decide**: keep `vim-rails` or delete
- `lua/plugins/extras/typescript.lua` + `lua/plugins/extras/react.lua` — see issue #10b (folded here)

## Problem

The `extras/` directory is supposed to be a truthful inventory of supported languages. Today it isn't:

| File | State | Detail |
|---|---|---|
| `python.lua` | Dead | Bare `{ pyright = {...} }` table — not a lazy spec. Not imported anywhere. |
| `lua.lua` | Dead duplicate | Bare `{ lua_ls = {...} }` table — never imported. `lspconfig.lua` already configures `lua_ls` fully (lines 117–138). |
| `html.lua` | Half-broken | Only extends `mason-lspconfig` with `emmet_ls`. Never registers `emmet_ls` in `opts.servers`. So mason installs it, but lspconfig never starts it. |
| `vue.lua` | Orphan | Fully written. Commented out at `lua/config/lazy.lua:34`. |
| `ruby.lua` | Stub | 4 lines (`tpope/vim-rails`, `ft = "ruby"`). No treesitter, no LSP. The README mentions ruby support as a "TODO". |
| `typescript.lua` ↔ `react.lua` | Duplicated | Both register `vtsls`. `react.lua` runs second and **overwrites** the `on_attach` and `filetypes` set by `typescript.lua`. |

## Solution

1. `rm lua/plugins/extras/python.lua` — pyright already in `lspconfig.lua:139`.
2. `rm lua/plugins/extras/lua.lua` — `lspconfig.lua:117–138` is the source of truth.
3. For `html.lua`: either complete it (add `opts.servers.emmet_ls = {...}` to the `neovim/nvim-lspconfig` spec) OR delete. **Recommendation**: complete, since `emmet_ls` is in the mason ensure-installed list and the install will keep happening.
4. For `vue.lua`: if you don't use Vue, delete the file AND keep the line commented in `lazy.lua`. If you do, uncomment the import and delete the commented line.
5. For `ruby.lua`: if you don't use ruby, delete. If you do, expand to add treesitter `ruby` parser and `ruby_lsp` (or `solargraph`) — but that's scope creep, file separately if so.
6. **Merge** `typescript.lua` and `react.lua` into a single `extras/typescript.lua` covering the union of filetypes (`typescript`, `typescriptreact`, `javascript`, `javascriptreact`). Delete `react.lua` and remove its import from `lazy.lua:36`.

## Acceptance criteria

- After the changes: `extras/python.lua`, `extras/lua.lua`, `extras/react.lua` are gone.
- `extras/html.lua` either registers the `emmet_ls` server in `opts.servers` or is deleted.
- `extras/vue.lua` and `extras/ruby.lua` decisions are recorded (in `CONTEXT.md` if kept; deleted if not).
- `lua/config/lazy.lua` no longer has a commented-out `vue` import (either uncommented or removed entirely).
- `:checkhealth lsp` after the change shows no orphan unconfigured servers in the mason ensure-installed list.

## Why this is hygiene, not deepening

This doesn't change the architecture; it makes the inventory honest. Locality wins are small but real. The combined typescript/react merge does eliminate one real bug (the `on_attach` overwrite).
