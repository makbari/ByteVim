# ByteVim

Personal Neovim configuration. LazyVim-derived layout (not LazyVim itself — see [ADR-0002](docs/adr/0002-lazyvim-derived-layout.md)). Mostly supports `typescript`, `python`, `rust`, `deno`, `golang`, `lua`, `vue`, `react`, and a handful of filetypes via filetype packs under `lua/plugins/extras/`.

See [`CONTEXT.md`](CONTEXT.md) for the domain glossary and [`docs/adr/`](docs/adr/) for architectural decisions.

---

# Keymaps

`<leader>` is **space**. `<localleader>` is **`;`**.

---

## LSP — `<leader>` and `g*`

Buffer-local; only set on `LspAttach`.

- **`gd` / `gD` / `gi` / `gr` / `gt`**: Definition / declaration / implementation / references / type-definition (via fzf-lua).
- **`K`**: Hover docs.
- **`<leader>sh`**: Signature help (one-shot). lsp_signature.nvim also shows it inline while typing.
- **`<leader>ca`**: Code actions.
- **`<leader>rn`**: Rename (IncRename — overrides plain `vim.lsp.buf.rename`).
- **`<leader>ed`**: Open diagnostics float.
- **`[d` / `]d`**: Previous / next diagnostic.
- **`<leader>ih`**: Toggle inlay hints (only registered if the server advertises support).

---

## Git — `<leader>g*`

Sub-namespaced by tool:

| Prefix | Owner |
|---|---|
| `<leader>gh*` | gitsigns (hunks) |
| `<leader>gb*` | git-blame |
| `<leader>gf*` | fzf-lua git pickers |
| `<leader>go*` | octo (GitHub) |
| `<leader>lg`  | lazygit |
| `<leader>gd`  | diffview toggle |

### Hunks (`gitsigns`)

- **`]h` / `[h`**: Next / previous hunk.
- **`<leader>ghs`** / **`<leader>ghr`**: Stage / reset current hunk (normal/visual).
- **`<leader>ghS`** / **`<leader>ghR`**: Stage / reset entire buffer.
- **`<leader>ghu`**: Undo hunk staging.
- **`<leader>ghp`**: Preview hunk inline.
- **`<leader>ghb`**: Blame current line (full).
- **`<leader>ghd`** / **`<leader>ghD`**: Diff this / diff this against `~`.
- **`ih`** (operator/visual): Select current hunk.

### Blame (`git-blame.nvim`)

- **`<leader>gbo`** / **`<leader>gbc`**: Open / copy commit URL.
- **`<leader>gbf`** / **`<leader>gbF`**: Open / copy file URL.
- **`<leader>gbs`**: Copy commit SHA.
- **`<leader>gbt`**: Toggle inline blame.

### Pickers (`fzf-lua` git)

- **`<leader>gfs`**: Git status.
- **`<leader>gfc`**: Git commits.
- **`<leader>gfb`**: Git branches.
- **`<leader>gfB`**: Buffer commits.

### GitHub (`octo`)

- **`<leader>goi`** / **`<leader>goI`**: List / search issues.
- **`<leader>gop`** / **`<leader>goP`**: List / search PRs.
- **`<leader>gor`**: List repos.
- **`<leader>gos`**: General search.

### Standalone

- **`<leader>lg`**: Open lazygit.
- **`<leader>gd`**: Toggle Diffview.

---

## Pickers — `fzf-lua` (`pickers.lua`)

- **`<C-g>`**: Live grep in project (normal); grep selection (visual).
- **`<leader>fi`** / **`<leader>fI`**: Find / grep all files including gitignored.
- **`<leader>ff`**: Find git-tracked files.
- **`<leader>F`**: Find all files (with hidden, follow symlinks).
- **`<leader>fr`**: Recent files (git root).
- **`<leader>fa`**: Search git-tracked files via `git grep`.
- **`<leader>fc`**: Find files in `~/.config/nvim`.
- **`<leader>/`**: Live grep in current directory.
- **`<leader>sb`** / **`<leader>sB`**: Search current buffer / open buffers.
- **`<leader>sw`** / **`<leader>sW`**: Search word / WORD under cursor (git root).
- **`<leader>sa`**: Find commands.
- **`<leader>ss`** / **`<leader>sS`**: LSP document / workspace symbols.
- **`<leader>si`** / **`<leader>so`**: LSP incoming / outgoing calls.
- **`<leader>sk`** / **`<leader>sm`** / **`<leader>sc`** / **`<leader>sh`** / **`<leader>sq`** / **`<leader>st`**: Keymaps / marks / colorschemes / help / quickfix / tmux buffers.

---

## Files (`files.lua`)

- **`<leader>er`**: Reveal current file in a floating Neo-tree.
- **`<leader><Tab>`**: Toggle Neo-tree on the left.
- **`<leader>sr`** (n/v): Search & replace via GrugFar.

---

## Navigation (`navigation.lua`)

### Harpoon

- **`<C-e>`**: Toggle quick menu.
- **`<leader>a`**: Add current file.
- **`<leader>h`** / **`<leader>j`** / **`<leader>k`** / **`<leader>l`**: Select marks 1–4.
- **`<leader><C-p>`** / **`<leader><C-n>`**: Next / previous mark.
- **`<leader>fm`**: Browse marks via fzf-lua.

### Motion (`flash.nvim`)

- **`s`** (n/x/o): Labelled jump anywhere visible.
- **`S`** (n/x/o): Labelled jump scoped by treesitter node.
- **`r`** (o): Remote flash (operator-pending).
- **`R`** (o/x): Treesitter search.
- **`<C-s>`** (c): Toggle flash search in cmdline.

### References & splits

- **`]]`** / **`[[`**: Next / previous reference (vim-illuminate).
- **`<C-h>`** / **`<C-j>`** / **`<C-k>`** / **`<C-l>`**: Move between Neovim/tmux splits.

---

## Diagnostics — `<leader>x*` (`refactor.lua`, trouble.nvim)

- **`<leader>xx`**: Workspace diagnostics.
- **`<leader>xX`**: Buffer diagnostics.
- **`<leader>xs`**: Symbols panel.
- **`<leader>xl`**: LSP defs/refs panel.
- **`<leader>xL`**: Location list.
- **`<leader>xQ`**: Quickfix list.
- **`<leader>xt`**: TODO list.

---

## Refactor (`refactor.lua`)

- **`<leader>S`**: Toggle Symbols Outline.
- **`<leader>rn`**: IncRename.
- **`<leader>rm`** (v): Refactoring menu.
- **`<leader>dv`** / **`<leader>dV`**: Print variable below / above.
- **`<leader>dc`**: Clear debug statements (refactoring.nvim).

---

## UI floats (`ui-floats.lua`)

- **`<leader>zz`**: Zen mode (wide, 140 cols).
- **`<leader>zZ`**: Zen mode (narrow, 80 cols).
- **`<leader>b`**: Toggle bafa.nvim (buffer list UI).

---

## Todo / Undo (`todo-undo.lua`)

- **`<leader>fT`**: Open TODO comments in quickfix.
- **`<leader>uT`**: Toggle UndoTree.

---

## Notes (`notes.lua`)

Floating markdown notes under `~/notes/`.

- **`<leader>nn`**: New floating note.
- **`<leader>fn`**: Find notes (fzf-lua).
- **`<leader>dn`**: Delete note.
- **`<Esc>`** (in float): Save and close.

---

## Coding (`coding.lua`)

- **`<leader>jd`**: JsDoc for JS/TS.
- **`<leader>ng`** / **`<leader>nf`** / **`<leader>nt`**: Neogen — general / function / type annotation.
- **`<A-h>` / `<A-l>` / `<A-j>` / `<A-k>`**: Move selection/line left / right / down / up (mini.move).

### mini.pairs / mini.surround / Comment.nvim defaults

- **`<CR>`** / **`<BS>`**: Pair-aware insert / delete.
- **`sa{motion}`** / **`sd`** / **`sr`** / **`sf`** / **`sF`** / **`sh`** / **`sn`**: Add / delete / replace / find-next / find-prev / highlight / change-neighbors surround.
- **`gcc`** / **`gc`** (v): Toggle line / block comment.

---

## AI (`ai.lua`, sidekick.nvim)

- **`<Tab>`**: Jump to / apply next edit suggestion.
- **`<C-.>`**: Toggle sidekick CLI.
- **`<leader>aa`** / **`<leader>as`**: Toggle / select CLI.
- **`<leader>at`** (n/x): Send `{this}`.
- **`<leader>af`**: Send file.
- **`<leader>av`** (x): Send visual selection.
- **`<leader>ap`** (n/x): Select prompt.
- **`<leader>ag`** / **`<leader>ac`**: Toggle Gemini / Claude.

---

## DAP (`dap.lua`)

- **`<leader>db`** / **`<leader>dB`**: Toggle / conditional breakpoint.
- **`<leader>dc`**: Continue.
- **`<leader>di`** / **`<leader>do`** / **`<leader>dO`**: Step into / over / out.
- **`<leader>dd`**: Select & run a DAP config.
- **`<leader>dl`**: Run last config.
- **`<leader>dt`**: Terminate.
- **`<leader>dr`**: Open REPL.
- **`<leader>de`** (n/v): Evaluate expression / selection.

---

## Tree-sitter — text objects & motion (`treesitter.lua`)

- **`<BS>`** (v): Decrement selection.
- **`]f` / `[f`**, **`]F` / `[F`**: Next/prev function start / end.
- **`]c` / `[c`**, **`]C` / `[C`**: Next/prev class start / end.
- **`]a` / `[a`**, **`]A` / `[A`**: Next/prev parameter start / end.
- **`]t` / `[t`**, **`]T` / `[T`**: Next/prev JSX/HTML tag start / end.
- **`]v` / `[v`**, **`]s` / `[s`**: Next/prev variable / scope start.
- **`<leader>at`** / **`<leader>it`**: Select around / inside JSX tag.
- **`<leader>sn`** / **`<leader>sp`**: Swap next / previous parameter/prop.

---

## Format (`formatting.lua`)

- **`<leader>cf`** (n/v): Format buffer (Conform).
- **`<leader>ctf`**: Toggle format-on-save.

---

## TypeScript / Deno / Angular / Vue / React on-attach

In a TypeScript file (`vtsls` attached):

- **`<leader>co`**: Organize imports.
- **`<leader>cM`**: Add missing imports.
- **`<leader>cu`**: Remove unused imports.
- **`<leader>cD`**: Fix all diagnostics.

---

## Rust on-attach (`extras/rust.lua`, `rustaceanvim`)

- **`<leader>cR`**: Rust code action.
- **`<leader>dr`**: Rust debuggables.
- Crate-pinning keymaps (in `Cargo.toml`): `<leader>ct/cv/cF/cd/cu/cU/ca/cA/cx/cX/cH/cR/cD/cC/cL` — see `extras/rust.lua` for the full set.

---

## Go on-attach (`extras/go.lua`, `go.nvim`)

- **`<leader>cG`**: Go code action.
- **`<leader>gt`** / **`<leader>gr`** / **`<leader>gb`** / **`<leader>gd`**: Go test / run / build / debug.

---

## Mason

- **`<leader>cm`**: Open Mason UI.

---

# Architecture

Bootstrap chain:

```
init.lua
  → lua/config/init.lua
     → utils (registers _G.ByteVim)
     → options
     → lazy (lazy.nvim spec entry point)
     → keymaps (vim core keymaps)
     → autocmds
     → colorscheme
```

Plugin layout:

```
lua/plugins/
├── ai.lua            AI assistants
├── coding.lua        Snippets, comments, pairs, surrounds, completion, signature, colorizer, rainbow brackets
├── colorscheme.lua   Themes
├── dap.lua           Debugger
├── files.lua         Neo-tree, GrugFar
├── formatting.lua    Conform
├── git.lua           gitsigns, lazygit, diffview, octo, git-blame, git-conflict
├── linting.lua       nvim-lint
├── lspconfig.lua     LSP base + servers (schemastore-backed jsonls/yamlls)
├── navigation.lua    Harpoon, flash, illuminate, tmux nav
├── notes.lua         Floating-window note system
├── pickers.lua       fzf-lua + goto-preview
├── refactor.lua      trouble, symbols-outline, inc-rename, refactoring.nvim
├── todo-undo.lua     todo-comments, undotree
├── treesitter.lua    Treesitter + textobjects + ts-autotag
├── ui-floats.lua     zen-mode, indent-blankline, ufo, better-escape, bafa
├── ui.lua            lualine, mini.icons, snacks dashboard
└── extras/<lang>.lua Per-language filetype packs
```

See [`CONTEXT.md`](CONTEXT.md) for the full domain language.
