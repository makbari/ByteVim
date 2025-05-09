local M = {}
function M.setup_keymaps()
  local keymaps = {
    {
      mode = "n",
      keys = "gd",
      func = function()
        require("telescope.builtin").lsp_definitions()
      end,
      desc = "Go to definition",
    },
    {
      mode = "n",
      keys = "gD",
      func = function()
        require("telescope.builtin").lsp_declarations()
      end,
      desc = "Go to declaration",
    },
    {
      mode = "n",
      keys = "gi",
      func = function()
        require("telescope.builtin").lsp_implementations()
      end,
      desc = "Go to implementation",
    },
    {
      mode = "n",
      keys = "gr",
      func = function()
        require("telescope.builtin").lsp_references()
      end,
      desc = "List references",
    },
    {
      mode = "n",
      keys = "gt",
      func = function()
        require("telescope.builtin").lsp_type_definitions()
      end,
      desc = "Go to type definition",
    },
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
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end,
      desc = "Toggle inlay hints",
    },
  }

  -- Loop through the keymap table and set keymaps
  for _, keymap in ipairs(keymaps) do
    ByteVim.utils.keymap(keymap.keys, keymap.func, keymap.desc, keymap.mode, nil)
  end

  local telescope = require("telescope.builtin")
  local function telescope_handler(handler)
    return function(err, result, ctx, config)
      handler(vim.tbl_extend("force", ctx, { jump_type = "never" }))
    end
  end

  vim.lsp.handlers["textDocument/codeAction"] = telescope_handler(telescope.lsp_code_actions)
  vim.lsp.handlers["textDocument/definition"] = telescope_handler(telescope.lsp_definitions)
  vim.lsp.handlers["textDocument/declaration"] = telescope_handler(telescope.lsp_declarations)
  vim.lsp.handlers["textDocument/typeDefinition"] = telescope_handler(telescope.lsp_type_definitions)
  vim.lsp.handlers["textDocument/implementation"] = telescope_handler(telescope.lsp_implementations)
  vim.lsp.handlers["textDocument/references"] = telescope_handler(telescope.lsp_references)
  vim.lsp.handlers["textDocument/documentSymbol"] = telescope_handler(telescope.lsp_document_symbols)
  vim.lsp.handlers["workspace/symbol"] = telescope_handler(telescope.lsp_workspace_symbols)
  vim.lsp.handlers["callHierarchy/incomingCalls"] = telescope_handler(telescope.lsp_incoming_calls)
  vim.lsp.handlers["callHierarchy/outgoingCalls"] = telescope_handler(telescope.lsp_outgoing_calls)
end

return M
