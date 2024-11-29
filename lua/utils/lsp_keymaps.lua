local M = {}
function M.setup_keymaps()
  local keymaps = {
    { mode = "n", keys = "gd", func = vim.lsp.buf.definition, desc = "Go to definition" },
    { mode = "n", keys = "gD", func = vim.lsp.buf.declaration, desc = "Go to declaration" },
    { mode = "n", keys = "gi", func = vim.lsp.buf.implementation, desc = "Go to implementation" },
    { mode = "n", keys = "gr", func = vim.lsp.buf.references, desc = "List references" },
    { mode = "n", keys = "gt", func = vim.lsp.buf.type_definition, desc = "Go to type definition" },
    { mode = "n", keys = "K", func = vim.lsp.buf.hover, desc = "Show documentation" },
    { mode = "n", keys = "<leader>sh", func = vim.lsp.buf.signature_help, desc = "Show signature help" },
    { mode = "n", keys = "<leader>ca", func = vim.lsp.buf.code_action, desc = "Code action" },
    { mode = "n", keys = "<leader>rn", func = vim.lsp.buf.rename, desc = "Rename symbol" },
    { mode = "n", keys = "<leader>ed", func = vim.diagnostic.open_float, desc = "Open diagnostics" },
    { mode = "n", keys = "[d", func = vim.diagnostic.goto_prev, desc = "Previous diagnostic" },
    { mode = "n", keys = "]d", func = vim.diagnostic.goto_next, desc = "Next diagnostic" },
    {
      mode = "n",
      keys = "<leader>ih",
      func = function()
        vim.lsp.inlay_hint(0, nil)
      end,
      desc = "Toggle inlay hints",
    },
  }

  -- Loop through the keymap table and set keymaps
  for _, keymap in ipairs(keymaps) do
    ByteVim.utils.keymap(keymap.keys, keymap.func, keymap.desc, keymap.mode, nil)
  end

  local fzf_lua = require("fzf-lua")

  vim.lsp.handlers["textDocument/codeAction"] = fzf_lua.lsp_code_actions
  vim.lsp.handlers["textDocument/definition"] = fzf_lua.lsp_definitions
  vim.lsp.handlers["textDocument/declaration"] = fzf_lua.lsp_declarations
  vim.lsp.handlers["textDocument/typeDefinition"] = fzf_lua.lsp_typedefs
  vim.lsp.handlers["textDocument/implementation"] = fzf_lua.lsp_implementations
  vim.lsp.handlers["textDocument/references"] = fzf_lua.lsp_references
  vim.lsp.handlers["textDocument/documentSymbol"] = fzf_lua.lsp_document_symbols
  vim.lsp.handlers["workspace/symbol"] = fzf_lua.lsp_workspace_symbols
  vim.lsp.handlers["callHierarchy/incomingCalls"] = fzf_lua.lsp_incoming_calls
  vim.lsp.handlers["callHierarchy/outgoingCalls"] = fzf_lua.lsp_outgoing_calls
end

return M
