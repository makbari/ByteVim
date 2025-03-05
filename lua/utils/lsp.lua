local Path = require("utils.path")

local M = {}

-- Find the root directory containing a specific config file
function M.get_config_path(filename)
  local current_dir = vim.fn.getcwd()
  local config_file = current_dir .. "/" .. filename
  if vim.fn.filereadable(config_file) == 1 then
    return current_dir
  end

  local git_root = Path.get_git_root()
  if Path.is_git_repo() and git_root ~= current_dir then
    config_file = git_root .. "/" .. filename
    if vim.fn.filereadable(config_file) == 1 then
      return git_root
    end
  end

  return nil
end

-- Check if deno.json exists
function M.deno_config_exist()
  return M.get_config_path("deno.json") ~= nil
end

-- Setup TypeScript or Deno LSP based on project config
function M.setup_typescript_lsp(capabilities)
  local lspconfig = require("lspconfig")
  local server_opts = { capabilities = capabilities }

  if M.deno_config_exist() then
    lspconfig.denols.setup(server_opts)
    vim.notify("Configured for Deno", vim.log.levels.INFO)
  elseif M.get_config_path("package.json") then
    lspconfig.ts_ls.setup(vim.tbl_deep_extend("force", server_opts, {
      settings = {
        code_lens = "off",
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "literals",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = false,
          includeInlayVariableTypeHints = true,
          includeInlayVariableTypeHintsWhenTypeMatchesName = false,
          includeInlayPropertyDeclarationTypeHints = false,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    }))
    vim.notify("Configured for TypeScript", vim.log.levels.INFO)
  end
end

-- LSP on_attach handler
function M.on_attach(client, bufnr)
  require("utils.lsp_keymaps").setup_keymaps()
  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end

return M
