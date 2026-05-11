# 03 — Move floating notes out of `utils/` into a plugin group

Status: ready-for-agent

## Files

- `lua/utils/notes.lua` (168 lines)
- `lua/utils/lsp_keymaps.lua` (lines 29–31 wire `ByteVim.notes.*`)
- `CONTEXT.md` — update "Floating note" entry

## Problem

`utils/notes.lua` is a feature (floating-window markdown notes under `~/notes/`), not a utility. It owns: filename generation, floating-window creation, `BufLeave` autosave, `<esc>` close, `fzf-lua` integration, delete-with-confirm. About 50 lines of nearly-identical floating-window setup are duplicated between `floating_note()` and the default action of `search_floating_notes()`.

It is also coupled to LSP attach: `lua/utils/lsp_keymaps.lua` registers `<leader>fn`, `<leader>nn`, `<leader>dn` for notes — so the LSP keymap surface includes note-taking. Two unrelated concerns coupled at the wrong seam.

## Solution

1. Create `lua/plugins/notes.lua` containing a plain plugin-style spec (it doesn't depend on a third-party plugin; use `lazy = true` with `keys = {}` to register the entry points). The spec's `config` (or a local `M.setup`) registers the three keymaps and the underlying functions.
2. Delete `lua/utils/notes.lua`.
3. Delete the notes-related keymaps from `lua/utils/lsp_keymaps.lua` (lines 29–31).
4. Extract the duplicated floating-window setup into a local helper inside `lua/plugins/notes.lua` (not into `utils/`, since today there's only one caller — one adapter is a hypothetical seam, not a real one).
5. Update `CONTEXT.md` — "Floating note" no longer lives in `utils/`; mention the new file.

## Acceptance criteria

- `lua/utils/notes.lua` is gone
- `ByteVim.notes` is no longer referenced anywhere (grep returns zero hits)
- `<leader>fn`, `<leader>nn`, `<leader>dn` still work after a restart
- LSP keymaps in `lua/utils/lsp_keymaps.lua` no longer reference notes
- `CONTEXT.md` reflects the move

## Why this is a deepening

Locality: notes is one file, one keymap surface, one trigger event. Leverage: the LSP keymap module shrinks to actual LSP keymaps. Deletion test for the floating-window helper: only one caller — keep it local to `notes.lua` until a second floating-window feature wants it (see also issue #03 in any future extraction).
