local M = {}
function M.setup_keymaps()
  local fzf_lua = require("fzf-lua")
  local keymaps = {
    { mode = "n", keys = "gd", func = fzf_lua.lsp_definitions, desc = "Go to definition" },
    { mode = "n", keys = "gD", func = fzf_lua.lsp_declarations, desc = "Go to declaration" },
    { mode = "n", keys = "gi", func = fzf_lua.lsp_implementations, desc = "Go to implementation" },
    { mode = "n", keys = "gr", func = fzf_lua.lsp_references, desc = "List references" },
    { mode = "n", keys = "gt", func = fzf_lua.lsp_typedefs, desc = "Go to type definition" },
    { mode = "n", keys = "<leader>ca", func = fzf_lua.lsp_code_actions, desc = "Code action" },
    { mode = "n", keys = "<leader>ss", func = fzf_lua.lsp_document_symbols, desc = "Document Symbols" },
    { mode = "n", keys = "<leader>sS", func = fzf_lua.lsp_workspace_symbols, desc = "Workspace Symbols" },
    { mode = "n", keys = "<leader>si", func = fzf_lua.lsp_incoming_calls, desc = "Incoming Calls" },
    { mode = "n", keys = "<leader>so", func = fzf_lua.lsp_outgoing_calls, desc = "Outgoing Calls" },
    { mode = "n", keys = "K", func = vim.lsp.buf.hover, desc = "Show documentation" },
    { mode = "n", keys = "<leader>sh", func = vim.lsp.buf.signature_help, desc = "Show signature help" },
    { mode = "n", keys = "<leader>rn", func = vim.lsp.buf.rename, desc = "Rename symbol" },
    { mode = "n", keys = "<leader>ed", func = vim.diagnostic.open_float, desc = "Open diagnostics" },
    { mode = "n", keys = "[d", func = vim.diagnostic.goto_prev, desc = "Previous diagnostic" },
    { mode = "n", keys = "]d", func = vim.diagnostic.goto_next, desc = "Next diagnostic" },
    {
      mode = "n",
      keys = "<leader>ih",
      func = function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end,
      desc = "Toggle inlay hints",
    },
    { mode = "n", keys = "<leader>fn", func = ByteVim.notes.search_floating_notes, desc = "Find Notes (fzf-lua)" },
    { mode = "n", keys = "<leader>nn", func = ByteVim.notes.floating_note, desc = "New Floating Note" },
    { mode = "n", keys = "<leader>dn", func = ByteVim.notes.delete_note, desc = "Delete Note" },
    { mode = "n", keys = "<leader>b", func = require("bafa").toggle, desc = "Toggle bafa.nvim UI" },
  }
  for _, keymap in ipairs(keymaps) do
    ByteVim.utils.keymap(keymap.keys, keymap.func, keymap.desc, keymap.mode)
  end
end
return M
