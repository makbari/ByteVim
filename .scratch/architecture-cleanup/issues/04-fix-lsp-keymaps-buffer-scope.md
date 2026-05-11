# 04 — `lsp_keymaps.setup_keymaps` silently drops its arguments

Status: ready-for-agent

## Files

- `lua/utils/lsp_keymaps.lua`
- Caller: `lua/plugins/lspconfig.lua:157`

## Problem

`lua/plugins/lspconfig.lua:157` calls:

```lua
ByteVim.lsp.on_attach(function(client, buffer)
  ByteVim.lsp_keymaps.setup_keymaps(client, buffer)
end)
```

But `lua/utils/lsp_keymaps.lua` defines:

```lua
function M.setup_keymaps()
```

— no parameters. The `client` and `buffer` arguments are silently discarded. The function calls `ByteVim.utils.keymap(...)` without a `buffer` opt, so every keymap is registered globally, not buffer-scoped.

Consequences:

- `K`, `gd`, `gr`, `[d`, `]d`, `<leader>ca`, `<leader>rn`, `<leader>ih`, etc. fire even in buffers with no LSP attached.
- These mappings shadow built-in `K` (keyword help), default `gd` behavior, and the diagnostic-navigation defaults regardless of whether an LSP server is present.
- The `client` argument can't be used to gate keymaps on server capability (e.g. only register `<leader>ih` if the server supports inlay hints).

## Additional cleanup (related)

The same file also wires up `<leader>fn`/`<leader>nn`/`<leader>dn` (notes) and `<leader>b` (bafa.toggle) — neither has anything to do with LSP. See issue #03 for moving notes out. The bafa keymap should move to wherever bafa is actually configured (currently `editor.lua:1031–1034` declares the plugin but doesn't register the keymap).

## Solution

```lua
function M.setup_keymaps(client, buffer)
  local opts = { buffer = buffer }
  -- ... use opts in every ByteVim.utils.keymap call
end
```

Pass `buffer` through to `ByteVim.utils.keymap` (which already accepts an `opts` arg). Optionally, gate `<leader>ih` (inlay hints) on `client:supports_method("textDocument/inlayHint")`.

## Acceptance criteria

- After the fix, opening a buffer with no LSP (e.g. a plain `.txt` file) does NOT register `K`, `gd`, `<leader>ca`, etc. — they fall back to built-in Vim behavior
- Opening a `.lua` or `.ts` file in a project with the right LSP DOES register them, scoped to that buffer
- Notes/bafa keymaps are removed from this file (per issue #03)
- The hardcoded `require("fzf-lua")` stays for now — see issue #05 for the picker seam

## Why this is a correctness fix

This is a bug, not a refactor — the documented contract (LSP keymaps on attach) isn't what the code does. Fixing it also tightens the seam: `lsp_keymaps` becomes about LSP keymaps only.
