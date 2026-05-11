# CONTEXT.md — ByteVim domain glossary

The language we use when talking about this Neovim configuration. Prefer these terms in issues, PRs, and refactor proposals over generic synonyms ("module", "service", "component").

---

## Bootstrap & runtime

**Init chain** — the ordered sequence loaded by `lua/config/init.lua`: utils → options → lazy → keymaps → autocmds → colorscheme. The order is load-bearing: utils must run first to populate `_G.ByteVim`; colorscheme last to override plugin highlights.

**Global namespace** — `_G.ByteVim`, exposed in `lua/config/init.lua:1` via `_G.ByteVim = require("utils")`. Submodules under `lua/utils/<name>.lua` are reachable as `ByteVim.<name>`, resolved lazily by the metatable in `lua/utils/init.lua`. Don't introduce new globals; extend `ByteVim` instead.

**Plugin manager** — `lazy.nvim`, configured in `lua/config/lazy.lua`. All plugin specs (and the extras imports) flow through one `require("lazy").setup({...})` call.

---

## Plugin organisation

**Plugin spec** — a Lua table returned from a `lua/plugins/*.lua` (or `extras/*.lua`) file, conforming to `lazy.nvim`'s spec format.

**Plugin group** — a file under `lua/plugins/` that bundles several plugin specs by topic: `pickers`, `navigation`, `files`, `refactor`, `ui-floats`, `todo-undo`, `coding`, `git`, `ui`, `lspconfig`, `treesitter`, `dap`, `formatting`, `linting`, `ai`, `colorscheme`, `notes`. The grouping is editorial, not enforced by lazy.nvim.

**Filetype pack** (a.k.a. **extras**) — a file under `lua/plugins/extras/` that extends the LSP server registry, treesitter parsers, mason ensure-installed list, and optionally adds filetype-specific plugins, for one language or framework (e.g. `rust.lua`, `typescript.lua`, `go.lua`). Imported individually in `lua/config/lazy.lua`'s `spec` block.

**LSP server registry** — the `opts.servers` table inside the `neovim/nvim-lspconfig` spec in `lua/plugins/lspconfig.lua`. Filetype packs extend it via `opts = function(_, opts) ... end`.

**Mason ensure-installed extension** — the pattern used by filetype packs to add tools/servers to install: `opts = function(_, opts) vim.list_extend(opts.ensure_installed, {...}) end`. Repeats across nearly every extras file.

---

## Concerns inside the editor

**Picker** — the fuzzy-finder UI used for files, grep, LSP symbols, etc. The repo currently runs two pickers in parallel: `fzf-lua` (primary) and `telescope.nvim` (used by harpoon's menu, refactoring.nvim's extension, octo.nvim, and the snacks dashboard). There is no single picker seam yet.

**Format-on-save** — the BufWritePre autocmd in `lua/plugins/formatting.lua` that calls `conform.format()` when the module-local `format_on_save_enabled` flag is true. Toggled via `<leader>ctf`.

**Lint-on-save** — the BufWritePost autocmd in `lua/plugins/linting.lua` that runs `nvim-lint` linters resolved by filetype, debounced 150ms.

**LSP attach hook** — `ByteVim.lsp.on_attach(fn)` in `lua/utils/lsp.lua:24`. Registers a callback to fire on `LspAttach`. The lspconfig spec uses it to wire up keymaps and dynamic capabilities.

**LSP capability gate** — `ByteVim.lsp.on_supports_method(method, fn)` in `lua/utils/lsp.lua:75`. Fires `fn` once per (client, buffer) when a client first advertises support for a method. Used to gate inlay hints and codelens on actual server capability.

**LSP disable predicate** — `ByteVim.lsp.disable(server, cond)` in `lua/utils/lsp.lua:100`. Suppresses a server from attaching when `cond(root_dir)` is true. Used in lspconfig.lua to resolve the `denols` ↔ `vtsls` conflict by root pattern.

**Project root** — `ByteVim.path.root()` in `lua/utils/path.lua`. Implements the LazyVim-style root detection spec `{ "lsp", { ".git", "lua" }, "cwd" }`: first the active LSP client's root, then nearest `.git`/`lua` ancestor, then cwd. Cached per buffer.

**Git root** — `ByteVim.path.git()`. Same as project root, then shells out to `git rev-parse --show-toplevel`. Used by fzf-lua keymaps to scope file/grep searches.

---

## Custom features

**Floating note** — the personal note-taking feature in `lua/plugins/notes.lua`. Creates dated markdown files under `~/notes/`, opens them in a centred floating window, autosaves on `BufLeave`. Keymaps: `<leader>nn` (new), `<leader>fn` (find), `<leader>dn` (delete).

**Bafa toggle** — buffer-line UI from `mistweaverco/bafa.nvim`, toggled with `<leader>b`. Wired into LSP keymaps (which is unrelated to LSP — incidental coupling).

---

## Terms to avoid

- **"Module"** as a generic term — say "plugin spec", "plugin group", "filetype pack", or "utils submodule".
- **"Service"** — there are no services in a Neovim config.
- **"Component"** — reserved for UI in other contexts; we have plugin specs and groups.
- **"LazyVim plugin"** — even though this config is LazyVim-derived, we don't depend on LazyVim itself. Say "filetype pack" or "plugin spec".

---

## Open language gaps

- There is no agreed term for "the seam that picks fzf-lua vs telescope". A future ADR may introduce one (proposal: **Picker adapter**).
- "Keymap registry" is not a real concept here yet — keymaps are scattered across `config/keymaps.lua`, plugin specs (`keys =`), and `utils/lsp_keymaps.lua`. If a single owner ever emerges, it needs a name.
