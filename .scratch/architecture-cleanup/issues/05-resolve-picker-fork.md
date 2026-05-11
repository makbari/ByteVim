# 05 — Resolve the `fzf-lua` vs `telescope.nvim` picker fork

Status: completed (2026-05-11) — Path A

Telescope removed. Changes:
- `lua/plugins/navigation.lua` — Harpoon menu rewritten using `fzf-lua.fzf_exec`
- `lua/plugins/git.lua` — `octo.opts.picker` changed from "telescope" to "fzf-lua"
- `lua/plugins/ui.lua` — Snacks dashboard "Find File" / "Recent Files" point at `:FzfLua files` / `:FzfLua oldfiles`
- `lua/plugins/refactor.lua` — dropped `telescope.load_extension("refactoring")`
- `lua/plugins/pickers.lua` — deleted `telescope.nvim` and `telescope-ui-select.nvim` specs
- `lua/plugins/extras/tailwindcss.lua` — dropped telescope dependency
- `lua/plugins/todo-undo.lua` — `<leader>fT` now points at `:TodoQuickFix` instead of `:TodoTelescope`
- `lua/plugins/colorscheme.lua` — `huez.nvim` removed (depended on telescope; `<leader>sc` via fzf-lua replaces it)
- `:Lazy clean` removed telescope.nvim, telescope-fzf-native.nvim, telescope-ui-select.nvim, huez.nvim from disk

## Files

- `lua/plugins/editor.lua` (fzf-lua spec + ~230 lines of config; harpoon uses `telescope.pickers`; refactoring loads `telescope.load_extension("refactoring")`; commented-out telescope spec lines 432–591)
- `lua/plugins/git.lua` (`octo` with `picker = "telescope"`)
- `lua/plugins/ui.lua` (snacks dashboard preset uses `:Telescope find_files` / `:Telescope oldfiles`)
- `lua/utils/lsp_keymaps.lua` (hardcodes `require("fzf-lua")`)
- `lua/plugins/extras/tailwindcss.lua` (`telescope.nvim` as dependency)

## Problem

`fzf-lua` is the *primary* picker used by ~30 user-facing keymaps. `telescope.nvim` is the *secret* picker used by Harpoon's menu, `refactoring.nvim`'s extension, `octo.nvim`, the Snacks dashboard, and the tailwindcss extra. There is no Picker adapter seam (term flagged as a gap in `CONTEXT.md`).

Removing either picker breaks features in surprising places. Adding a third (e.g. Snacks' picker) makes it worse.

## Two viable paths

### Path A — Pick one picker, rip out the other

Most LazyVim-derived configs in 2026 use either `snacks.picker` or `fzf-lua` exclusively.

- **If keep `fzf-lua`**: remove `telescope.nvim` and `telescope-ui-select`. Rewrite Harpoon's menu using `fzf-lua` (there are recipes online), drop `refactoring.nvim`'s telescope extension and use `vim.ui.select` (which `fzf-lua` already overrides), switch `octo` to a different picker (it may not have a fzf option — check current Octo docs), update the Snacks dashboard actions to use `:FzfLua files` / `:FzfLua oldfiles`.
- **If switch to `snacks.picker`**: bigger move, but Snacks is already installed for the dashboard.

### Path B — Introduce a `ByteVim.picker` adapter

Keep both pickers, but localise the choice behind one seam:

```lua
-- lua/utils/picker.lua
local M = {}
function M.files(opts) require("fzf-lua").files(opts) end
function M.live_grep(opts) require("fzf-lua").live_grep(opts) end
function M.lsp_definitions(opts) require("fzf-lua").lsp_definitions(opts) end
-- ... etc
return M
```

`lsp_keymaps.lua` and `editor.lua` call `ByteVim.picker.*` instead of `fzf-lua` directly. Telescope stays only as a dependency for plugins that hardcode it. Document that no new code may `require("fzf-lua")` or `require("telescope.*")` directly — only `ByteVim.picker`.

## Tradeoffs

| Aspect | Path A (one picker) | Path B (adapter) |
|---|---|---|
| Depth | High — one picker, one config, one seam | Medium — adapter is a real seam but two implementations co-exist |
| Effort | High (rewrites needed) | Low (mechanical wrap) |
| Risk | Medium (Harpoon/Octo behavior may change) | Low (no behavior changes today) |
| Future flexibility | Locked in | Easy to swap one day |

## Open questions (need maintainer input)

1. Do you actively want to swap pickers in the future, or is this a "pick once, forget" decision?
2. Are you attached to the Harpoon telescope menu or fine with a fzf-lua replacement?
3. Is the Snacks dashboard preset something you care about, or can the dashboard be reconfigured?

## Deletion test

- Path A passes cleanly (delete telescope, complexity does NOT reappear — features move to fzf-lua, single seam).
- Path B passes weakly (adapter today has one real implementation; "one adapter = hypothetical seam" — only worth it if path A is too expensive right now).

## Recommendation

Path A. Mixed-picker setups rot; the secret-telescope dependencies are exactly the kind of trap that bites a year from now when you try to remove "the unused telescope plugin".

Awaiting decision before this can move to `ready-for-agent`.
