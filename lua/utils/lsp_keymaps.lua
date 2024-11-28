local M = {}

M._keys = nil

--- Retrieve LSP-specific keymaps
---@return table[]
function M.get()
  if M._keys then
    return M._keys
  end

  M._keys = {
    { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
    { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
    { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
    { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
    { "gy", vim.lsp.buf.type_definition, desc = "Goto Type Definition" },
    { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
    { "K", vim.lsp.buf.hover, desc = "Hover" },
    { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
    { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },
    { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" },
    { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
    { "<leader>cc", vim.lsp.codelens.run, desc = "Run CodeLens", has = "codeLens" },
    { "<leader>cC", vim.lsp.codelens.refresh, desc = "Refresh CodeLens", has = "codeLens" },
  }

  return M._keys
end

--- Check if the LSP client supports a specific method
---@param buffer number
---@param method string|string[]
---@return boolean
function M.has(buffer, method)
  if type(method) == "table" then
    for _, m in ipairs(method) do
      if M.has(buffer, m) then
        return true
      end
    end
    return false
  end

  method = method:find("/") and method or "textDocument/" .. method
  local clients = vim.lsp.get_active_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    if client.supports_method(method) then
      return true
    end
  end

  return false
end

--- Apply keymaps on LSP attach
---@param client table
---@param buffer number
function M.on_attach(client, buffer)
  for _, keys in ipairs(M.get()) do
    local has = not keys.has or M.has(buffer, keys.has)
    local cond = not (keys.cond == false or (type(keys.cond) == "function" and not keys.cond()))

    if has and cond then
      local opts = {
        silent = keys.silent ~= false,
        buffer = buffer,
        desc = keys.desc,
      }
      vim.keymap.set(keys.mode or "n", keys[1], keys[2], opts)
    end
  end
end

return M
