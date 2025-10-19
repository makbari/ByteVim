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

## Git Keymaps (`git.lua`)

### Custom Keymaps

Keymaps for Git operations.

- **`<leader>lg`**: Opens LazyGit interface.
- **`]h`**: Moves to next Git hunk.
- **`[h`**: Moves to previous Git hunk.
- **`<leader>ghs`**: Stages current hunk (normal/visual).
- **`<leader>ghr`**: Resets current hunk (normal/visual).
- **`<leader>ghS`**: Stages entire buffer.
- **`<leader>ghu`**: Undoes hunk staging.
- **`<leader>ghR`**: Resets entire buffer.
- **`<leader>ghp`**: Previews hunk inline.
- **`<leader>ghb`**: Shows blame for current line.
- **`<leader>ghd`**: Shows diff for current file.
- **`<leader>ghD`**: Shows diff against previous commit.
- **`ih`**: Selects current hunk (operator/visual).
- **`<leader>dfv`**: Toggles Diffview plugin.

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

## Editor Keymaps (`editor.lua`)

### Custom Keymaps

Keymaps for editor navigation, searching, and Git tasks.

- **`<leader>er`**: Opens Neo-tree in floating window.
- **`<leader><Tab>`**: Toggles Neo-tree on left.
- **`<leader>sr`**: Opens GrugFar for search/replace (normal/visual).
- **`<leader>gB`**: Opens commit URL (GitBlame).
- **`<leader>gc`**: Copies commit URL (GitBlame).
- **`<leader>gf`**: Opens file URL (GitBlame).
- **`<leader>gC`**: Copies file URL (GitBlame).
- **`<leader>gs`**: Copies commit SHA (GitBlame).
- **`<leader>gt`**: Toggles Git blame (GitBlame).
- **`<C-g>`**: Searches files with Telescope live grep (normal); greps selection (visual).
- **`<leader>sw`**: Greps selection (visual) or word under cursor (normal) in Git root.
- **`<leader>fr`**: Finds recent files in Git root (Telescope).
- **`<leader>/`**: Greps files in current directory (Telescope).
- **`<leader>ff`**: Finds Git-tracked files in Git root (Telescope).
- **`<leader>fc`**: Finds Neovim config files (Telescope).
- **`<leader>sb`**: Searches current buffer (Telescope).
- **`<leader>sB`**: Searches open buffers (Telescope).
- **`<leader>sW`**: Searches exact WORD in Git root (Telescope).
- **`<leader>gs`**: Shows Git status (Telescope).
- **`<leader>gc`**: Shows Git commits (Telescope).
- **`<leader>gb`**: Shows Git branches (Telescope).
- **`<leader>gB`**: Shows buffer commits (Telescope).
- **`<leader>sa`**: Finds commands (Telescope).
- **`<leader>s:`**: Searches command history (Telescope).
- **`<leader>ss`**: Shows LSP document symbols (Telescope).
- **`<leader>sS`**: Shows LSP workspace symbols (Telescope).
- **`<leader>si`**: Shows LSP incoming calls (Telescope).
- **`<leader>so`**: Shows LSP outgoing calls (Telescope).
- **`<leader>sk`**: Searches keymaps (Telescope).
- **`<leader>sm`**: Searches marks (Telescope).
- **`<leader>sc`**: Searches colorschemes (Telescope).
- **`<leader>sh`**: Searches help tags (Telescope).
- **`<leader>sq`**: Searches quickfix list (Telescope).
- **`<leader>fm`**: Opens Harpoon marks in Telescope.
- **`<C-e>`**: Toggles Harpoon quick menu.
- **`<leader>a`**: Adds file to Harpoon.
- **`<leader>h`**: Selects Harpoon mark 1.
- **`<leader>j`**: Selects Harpoon mark 2.
- **`<leader>k`**: Selects Harpoon mark 3.
- **`<leader>l`**: Selects Harpoon mark 4.
- **`<leader><C-p>`**: Navigates to next Harpoon mark.
- **`<leader><C-n>`**: Navigates to previous Harpoon mark.
- **`]]`**: Moves to next reference (vim-illuminate).
- **`[[`**: Moves to previous reference (vim-illuminate).
- **`<leader>S`**: Toggles Symbols Outline.
- **`<leader>rn`**: Opens IncRename command (overwrites LSP rename).
- **`<leader>rm`**: Opens refactoring menu (visual).
- **`<leader>dv`**: Prints variables below (normal/visual).
- **`<leader>dV`**: Prints variables above (normal/visual).
- **`<leader>dc`**: Clears debugging statements.
- **`<C-h>`**: Moves to left Tmux window.
- **`<C-j>`**: Moves to downward Tmux window.
- **`<C-k>`**: Moves to upward Tmux window.
- **`<C-l>`**: Moves to right Tmux window.
- **`<leader>fT`**: Searches TODO comments (Telescope).
- **`<leader>uT`**: Toggles UndoTree window.
- **`<leader>zz`**: Toggles Zen mode (wide, 140 columns).
- **`<leader>zZ`**: Toggles Zen mode (narrow, 80 columns).

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
