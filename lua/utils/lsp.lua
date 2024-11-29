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
function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf ---@type number
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
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

function M.setup(options)
  -- Default options with sensible values
  options = vim.tbl_deep_extend("force", {
    servers = {},
    inlay_hints = { enabled = true },
    setup = {},
  }, options or {})

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
  capabilities = vim.tbl_deep_extend("force", capabilities, cmp_capabilities)

  require("mason-lspconfig").setup({
    ensure_installed = vim.tbl_keys(options.servers), -- Automatically install listed servers
  })

  -- Setup each server
  for server_name, server_options in pairs(options.servers) do
    local server_config = vim.tbl_deep_extend("force", {
      capabilities = capabilities,
      on_attach = function(client, buffer)
        ByteVim.lsp_keymaps.setup_keymaps(client, buffer)
        if vim.fn.has("nvim-0.10") == 1 then
          -- Inlay hints
          if options.inlay_hints.enabled then
            vim.api.nvim_create_autocmd("LspAttach", {
              callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                local buffer = args.buf

                -- Ensure buffer is valid and not excluded
                if
                  client
                  and vim.api.nvim_buf_is_valid(buffer)
                  and vim.bo[buffer].buftype == ""
                  and not vim.tbl_contains(options.inlay_hints.exclude or {}, vim.bo[buffer].filetype)
                  and client.supports_method("textDocument/inlayHint")
                then
                  -- Check if inlay_hint is available and a function
                  local inlay_hint_available, inlay_hint = pcall(function()
                    return vim.lsp.inlay_hint
                  end)

                  if inlay_hint_available and type(inlay_hint) == "function" then
                    -- Enable inlay hints
                    inlay_hint(buffer, true)
                  end
                end
              end,
            })
          end
        end

        -- Additional buffer-specific on_attach actions
        M.on_attach(function(_, _)
          -- Add additional mappings or configurations if necessary
        end)
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

return M
