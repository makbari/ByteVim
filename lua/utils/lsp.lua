local Path = require("utils.path")

local M = {}

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

function M.stop_lsp_client_by_name(name)
  local clients = vim.lsp.get_active_clients()
  for _, client in ipairs(clients) do
    if client.name == name then
      vim.lsp.stop_client(client.id, true)
      vim.notify("Stopped LSP client: " .. name)
      return
    end
  end
  vim.notify("No active LSP client with name: " .. name)
end

function M.dprint_config_path()
  return M.get_config_path("dprint.json")
end

function M.dprint_config_exist()
  local has_config = M.get_config_path("dprint.json")
  return has_config ~= nil
end

function M.deno_config_exist()
  local has_json_config = M.get_config_path("deno.json")
  return has_json_config ~= nil
end

function M.eslint_config_exists()
  local current_dir = vim.fn.getcwd()
  local config_files =
    { ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.yaml", ".eslintrc.yml", ".eslintrc.json", ".eslintrc" }

  for _, file in ipairs(config_files) do
    local config_file = current_dir .. "/" .. file
    if vim.fn.filereadable(config_file) == 1 then
      return true
    end
  end

  local git_root = Path.get_git_root()
  if Path.is_git_repo() and git_root ~= current_dir then
    for _, file in ipairs(config_files) do
      local config_file = git_root .. "/" .. file
      if vim.fn.filereadable(config_file) == 1 then
        return true
      end
    end
  end

  return false
end
---@param fn fun()
function M.on_very_lazy(fn)
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      fn()
    end,
  })
end

function M.setup_typescript_lsp(capabilities)
  local server_opts = { capabilities = capabilities }
  local lspconfig = require("lspconfig")
  -- Check if it's a Deno project
  if M.deno_config_exist() then
    lspconfig.denols.setup(server_opts)
    vim.notify("Configured for Deno", vim.log.levels.INFO)
  elseif M.get_config_path("package.json") then
    -- Configure for TypeScript if package.json exists
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
function M.setup(options)
  local nvim_lsp = require("lspconfig")
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
  capabilities = vim.tbl_deep_extend("force", capabilities, cmp_capabilities)

  -- Default options with sensible values

  options = vim.tbl_deep_extend("force", {
    servers = {},
    inlay_hints = { enabled = true },
    setup = {},
  }, options or {})
  local mason_lspconfig = require("mason-lspconfig")
  mason_lspconfig.setup({
    ensure_installed = vim.tbl_keys(options.servers), -- Automatically install listed servers
  })
  mason_lspconfig.setup_handlers({
    function(server_name)
      if server_name == "ts_ls" or server_name == "deno_ls" then
        M.setup_typescript_lsp(capabilities)
      else
        local server_opts = vim.tbl_deep_extend("force", { capabilities = capabilities }, options.servers[server] or {})
        if server_name.enabled then
          nvim_lsp[server_name].setup(server_opts)
        end
      end
    end,
  })
  -- Setup each server
  for server_name, server_options in pairs(options.servers) do
    local server_config = vim.tbl_deep_extend("force", {
      capabilities = capabilities,
      on_attach = function()
        print(vim.fn.has("nvim-0.10"))
        if vim.fn.has("nvim-0.10") == 1 then
          -- Inlay hints
          if options.inlay_hints.enabled then
            vim.api.nvim_create_autocmd("LspAttach", {
              callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                local buffer = args.buf
                if
                  client
                  and vim.api.nvim_buf_is_valid(buffer)
                  and vim.bo[buffer].buftype == ""
                  and not vim.tbl_contains(options.inlay_hints.exclude or {}, vim.bo[buffer].filetype)
                  and client.supports_method("textDocument/inlayHint")
                then
                  if vim.lsp.inlay_hint then
                    vim.lsp.inlay_hint.enable(buffer, true)
                  end
                end
              end,
            })
          end
        end
      end,
    }, server_options)

    -- If there's a custom setup function for this server, use it
    if options.setup[server_name] then
      options.setup[server_name](require("lspconfig")[server_name], server_config)
    else
      require("lspconfig")[server_name].setup(server_config)
    end
  end
end
function M.on_attach(client, bufnr)
  require("utils.lsp_keymaps").setup_keymaps()
  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(bufnr, true)
  end
end
return M
