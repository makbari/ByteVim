# Description

This is a `neovim` config personal use in different environments.
Mostly support `typescript`, `python`, `rust`, `deno`, `golang`.

this is based on `Lazyvim` config, but since, i do not have a time to configure it, I grab the parts I want, simplified it and create this.

Most of the keymaps are documented, but there could be couple of keymaps missing.

# Neovim All Keymaps

This document lists all keymaps defined in the provided Neovim configuration files (`lsp_keymaps.lua`, `deno.lua`, `typescript.lua`, `git.lua`, `coding.lua`, `linting.lua`, `editor.lua`, `treesitter.lua`, `ui.lua`, `formatting.lua`), including both **custom keymaps** explicitly defined in the configuration and **default keymaps** provided by plugins, as sourced from plugin documentation and web resources. Each keymap includes a one-sentence explanation and is organized by file, with custom and default keymaps separated for clarity.

---

## LSP Keymaps (`lsp_keymaps.lua`)

### Custom Keymaps

Keymaps for Language Server Protocol (LSP) navigation and actions.

- **`gd`**: Navigates to symbol definition using Telescope.
- **`gD`**: Navigates to symbol declaration using Telescope.
- **`gi`**: Navigates to symbol implementation using Telescope.
- **`gr`**: Lists symbol references using Telescope.
- **`gt`**: Navigates to type definition using Telescope.
- **`K`**: Displays symbol documentation via LSP hover.
- **`<leader>sh`**: Shows function signature help via LSP.
- **`<leader>ca`**: Triggers code actions via LSP.
- **`<leader>rn`**: Renames symbol via LSP.
- **`<leader>ed`**: Opens floating diagnostics window.
- **`[d`**: Moves to previous diagnostic.
- **`]d`**: Moves to next diagnostic.
- **`<leader>ih`**: Toggles LSP inlay hints.

---

## TypeScript Keymaps (`typescript.lua`)

### Custom Keymaps

Keymaps for TypeScript development with `twoslash-queries.nvim`.

- **`<leader>dt`**: Enables twoslash queries for type information.
- **`<leader>dd`**: Inspects twoslash query results.

---

## Git Keymaps (`git.lua`, `pickers.lua`)

All git-related keymaps live under `<leader>g*`, sub-namespaced by tool:

- **`<leader>gh*`** — gitsigns hunks
- **`<leader>gb*`** — git-blame
- **`<leader>gf*`** — fzf-lua git pickers
- **`<leader>go*`** — octo (GitHub)
- **`<leader>lg`** — lazygit
- **`<leader>gd`** — diffview toggle

### Hunks (gitsigns) — `<leader>gh*`

- **`]h`**: Next Git hunk.
- **`[h`**: Previous Git hunk.
- **`<leader>ghs`**: Stage current hunk (normal/visual).
- **`<leader>ghr`**: Reset current hunk (normal/visual).
- **`<leader>ghS`**: Stage entire buffer.
- **`<leader>ghu`**: Undo hunk staging.
- **`<leader>ghR`**: Reset entire buffer.
- **`<leader>ghp`**: Preview hunk inline.
- **`<leader>ghb`**: Blame current line.
- **`<leader>ghd`**: Diff current file.
- **`<leader>ghD`**: Diff against previous commit.
- **`ih`**: Select current hunk (operator/visual).

### Blame (git-blame.nvim) — `<leader>gb*`

- **`<leader>gbo`**: Open commit URL in browser.
- **`<leader>gbc`**: Copy commit URL.
- **`<leader>gbf`**: Open file URL in browser.
- **`<leader>gbF`**: Copy file URL.
- **`<leader>gbs`**: Copy commit SHA.
- **`<leader>gbt`**: Toggle inline blame.

### Pickers (fzf-lua) — `<leader>gf*`

- **`<leader>gfs`**: Git status picker.
- **`<leader>gfc`**: Git commits picker.
- **`<leader>gfb`**: Git branches picker.
- **`<leader>gfB`**: Buffer commits picker.

### GitHub (octo) — `<leader>go*`

- **`<leader>goi`**: List issues.
- **`<leader>goI`**: Search issues.
- **`<leader>gop`**: List PRs.
- **`<leader>goP`**: Search PRs.
- **`<leader>gor`**: List repos.
- **`<leader>gos`**: General search.

### Standalone

- **`<leader>lg`**: Open lazygit.
- **`<leader>gd`**: Toggle Diffview.

---

## Coding Keymaps (`coding.lua`)

### Custom Keymaps

Keymaps for coding tasks like documentation and code movement.

- **`<leader>jd`**: Generates JsDoc for JavaScript/TypeScript.
- **`<leader>ng`**: Generates general code annotations (Neogen).
- **`<leader>nf`**: Generates function annotation (Neogen).
- **`<leader>nt`**: Generates type annotation (Neogen).
- **`<A-h>`**: Moves selection/line left (normal/visual).
- **`<A-l>`**: Moves selection/line right (normal/visual).
- **`<A-j>`**: Moves selection/line down (normal/visual).
- **`<A-k>`**: Moves selection/line up (normal/visual).

### Default Keymaps

Default keymaps from `mini.pairs`, `mini.surround`, and `Comment.nvim`.

- **`<CR>`** (`mini.pairs`): Confirms pair insertion or moves to the next line if no pair is needed.
- **`Backspace`** (`mini.pairs`): Deletes the pair if the cursor is between matching delimiters, otherwise deletes a single character.
- **`sa`** (`mini.surround`, visual/motion): Adds a surrounding pair around the selected text or motion.
- **`sd`** (`mini.surround`): Deletes the surrounding pair around the cursor.
- **`sr`** (`mini.surround`): Replaces the surrounding pair with a new one.
- **`sf`** (`mini.surround`): Moves the cursor to the next surrounding pair.
- **`sF`** (`mini.surround`): Moves the cursor to the previous surrounding pair.
- **`sh`** (`mini.surround`): Highlights the surrounding pair.
- **`sn`** (`mini.surround`): Changes the number of neighbor lines for surrounding operations.
- **`gcc`** (`Comment.nvim`): Toggles comment on the current line.
- **`gc`** (`Comment.nvim`, visual): Toggles comment on the selected lines.

---

## Editor Keymaps

Plugins previously bundled in `editor.lua` now live in `pickers.lua`, `navigation.lua`, `files.lua`, `refactor.lua`, `ui-floats.lua`, and `todo-undo.lua`.

### Files (`files.lua`)

- **`<leader>er`**: Open Neo-tree in floating window.
- **`<leader><Tab>`**: Toggle Neo-tree on left.
- **`<leader>sr`**: Open GrugFar for search/replace (normal/visual).

### Pickers — fzf-lua (`pickers.lua`)

- **`<C-g>`**: Live grep in project (normal/visual).
- **`<leader>fi`**: Find all files including gitignored.
- **`<leader>fI`**: Grep all files including gitignored.
- **`<leader>fr`**: Recent files (git root).
- **`<leader>/`**: Live grep in current directory.
- **`<leader>fa`**: Search git-tracked files (`git grep`).
- **`<leader>F`**: Find all files (with hidden).
- **`<leader>ff`**: Find git files.
- **`<leader>fc`**: Find files in Neovim config.
- **`<leader>sb`**: Search current buffer.
- **`<leader>sB`**: Search lines in open buffers.
- **`<leader>sw`** / **`<leader>sW`**: Search word/WORD under cursor (git root).
- **`<leader>sa`**: Find commands.
- **`<leader>ss`** / **`<leader>sS`**: LSP document/workspace symbols.
- **`<leader>si`** / **`<leader>so`**: LSP incoming/outgoing calls.
- **`<leader>sk`** / **`<leader>sm`** / **`<leader>sc`** / **`<leader>sh`** / **`<leader>sq`**: Keymaps / marks / colorschemes / help / quickfix.

### Navigation (`navigation.lua`)

- **`<C-e>`**: Toggle Harpoon quick menu.
- **`<leader>a`**: Add file to Harpoon.
- **`<leader>h`** / **`<leader>j`** / **`<leader>k`** / **`<leader>l`**: Select Harpoon marks 1–4.
- **`<leader><C-p>`** / **`<leader><C-n>`**: Next/previous Harpoon mark.
- **`<leader>fm`**: Open Harpoon marks in Telescope.
- **`]]`** / **`[[`**: Next/previous reference (vim-illuminate).
- **`<C-h>`** / **`<C-j>`** / **`<C-k>`** / **`<C-l>`**: Move between Tmux/Neovim splits.

### Refactor (`refactor.lua`)

- **`<leader>S`**: Toggle Symbols Outline.
- **`<leader>rn`**: IncRename (overrides LSP rename).
- **`<leader>rm`**: Refactoring menu (visual).
- **`<leader>dv`** / **`<leader>dV`**: Print variable below/above (refactoring.nvim).
- **`<leader>dc`**: Clear debugging statements.

### UI floats (`ui-floats.lua`)

- **`<leader>zz`**: Zen mode (wide, 140 cols).
- **`<leader>zZ`**: Zen mode (narrow, 80 cols).
- **`<leader>b`**: Toggle bafa.nvim.

### Todo & undo (`todo-undo.lua`)

- **`<leader>fT`**: TodoTelescope (search TODO comments).
- **`<leader>uT`**: Toggle UndoTree.

### Notes (`notes.lua`)

- **`<leader>nn`**: New floating note.
- **`<leader>fn`**: Find notes.
- **`<leader>dn`**: Delete note.

### Default Keymaps

Default keymaps from `goto-preview` with `default_mappings = true`.

- **`gpd`** (`goto-preview`): Previews the definition of the symbol under the cursor in a floating window.
- **`gpi`** (`goto-preview`): Previews the implementation of the symbol under the cursor in a floating window.
- **`gP`** (`goto-preview`): Closes all preview windows.
- **`gpr`** (`goto-preview`): Previews references for the symbol under the cursor in a floating window (if supported by the LSP).

---

---

## DAP Keymaps (`dap.lua`)

### Custom Keymaps

Keymaps for debugging with DAP.

- **`<leader>db`**: Toggles breakpoint at current line.
- **`<leader>dB`**: Sets conditional breakpoint at current line.
- **`<leader>dc`**: Continues execution from current breakpoint.
- **`<leader>di`**: Steps into the current function call.
- **`<leader>do`**: Steps over the current line.
- **`<leader>dO`**: Steps out of the current function.
- **`<leader>dd`**: Selects and runs a DAP configuration.
- **`<leader>dl`**: Runs the last DAP configuration.
- **`<leader>dt`**: Terminates the current debugging session.
- **`<leader>de`**: Evaluates expression under cursor (normal) or selection (visual).

---
## Tree-sitter Keymaps (`treesitter.lua`)

### Custom Keymaps

Keymaps for Tree-sitter navigation and selection.

- **`<BS>`**: Decrements selection in visual mode.
- **`]f`**: Moves to next function start.
- **`]c`**: Moves to next class start.
- **`]a`**: Moves to next parameter start.
- **`]t`**: Moves to next JSX/HTML tag start.
- **`]F`**: Moves to next function end.
- **`]C`**: Moves to next class end.
- **`]A`**: Moves to next parameter end.
- **`]T`**: Moves to next JSX/HTML tag end.
- **`[f`**: Moves to previous function start.
- **`[c`**: Moves to previous class start.
- **`[a`**: Moves to previous parameter start.
- **`[t`**: Moves to previous JSX/HTML tag start.
- **`[F`**: Moves to previous function end.
- **`[C`**: Moves to previous class end.
- **`[A`**: Moves to previous parameter end.
- **`[T`**: Moves to previous JSX/HTML tag end.
- **`<leader>at`**: Selects around JSX tag.
- **`<leader>it`**: Selects inside JSX tag.

---

## Formatting Keymaps (`formatting.lua`)

### Custom Keymaps

Keymap for code formatting.

- **`<leader>cf`**: Formats buffer using Conform (normal/visual).

---

This document comprehensively covers all keymaps from the specified Neovim configuration files, including custom keymaps explicitly defined in the Lua files and default keymaps provided by plugins, sourced from plugin documentation and web resources (e.g., GitHub repositories, plugin READMEs). Each keymap is accompanied by a brief explanation, with custom and default keymaps clearly separated for clarity.
