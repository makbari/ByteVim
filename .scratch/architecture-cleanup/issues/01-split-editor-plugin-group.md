# 01 — Split the `editor` plugin group by concern

Status: ready-for-agent

## Files

- `lua/plugins/editor.lua` (1035 lines, ~16 unrelated plugin specs)

## Problem

The `editor` plugin group is a junk drawer. It holds the file explorer, two pickers, navigation plugins, refactoring UI, UI-float widgets, TODO/undo, and even `git-blame.nvim` (which belongs in the `git` plugin group). The grouping is shallow at its interface: lazy.nvim gets nothing useful from "editor-ness", while the implementation is a thousand lines. Understanding one concept means scanning the whole file.

Lines 432–591 are a commented-out telescope spec — dead code that should also go.

## Solution

Split into thematic plugin groups under `lua/plugins/`:

- `pickers.lua` — `fzf-lua`, `goto-preview`, `telescope.nvim`, `telescope-ui-select`
- `navigation.lua` — `harpoon`, `vim-illuminate`, `tmux.nvim`
- `files.lua` — `neo-tree.nvim`, `grug-far.nvim`
- `refactor.lua` — `refactoring.nvim`, `inc-rename.nvim`, `symbols-outline.nvim`
- `ui-floats.lua` — `zen-mode.nvim`, `indent-blankline.nvim`, `nvim-ufo`, `better-escape.nvim`, `bafa.nvim`
- `todo-and-undo.lua` (or fold into `ui-floats.lua`) — `todo-comments.nvim`, `undotree`

Move `git-blame.nvim` (lines 133–173) into `lua/plugins/git.lua` — see issue #07.

Delete the commented-out telescope spec (lines 432–591).

## Acceptance criteria

- `lua/plugins/editor.lua` no longer exists, OR is reduced to a small residue with a clear purpose
- Each new plugin group file is under ~250 lines
- No commented-out plugin specs remain in the moved-from file
- All keymaps documented in `readme.md` still fire (verify by opening Neovim and trying a sample from each group)
- `lazy.nvim` auto-imports the new files via `{ import = "plugins" }` — no changes needed in `lua/config/lazy.lua`

## Why this is a deepening

Locality wins: each plugin group is one concept, ~50–200 lines, readable in one screen. Leverage: swapping a picker or a navigation plugin touches one file. Deletion test passes — the new groups concentrate their topic's complexity rather than spreading it.
