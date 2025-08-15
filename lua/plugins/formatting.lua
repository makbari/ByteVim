local M = {}

-- Add a variable to track the formatting state
local format_on_save_enabled = true

function M.toggle_format_on_save()
  format_on_save_enabled = not format_on_save_enabled
  local msg = format_on_save_enabled and "Enabled formatting on save" or "Disabled formatting on save"
  vim.notify(msg, vim.log.levels.INFO)
end

function M.setup(_, opts)
  for _, key in ipairs({ "format_on_save", "format_after_save" }) do
    if opts[key] then
      local msg = "Don't set `opts.%s` for `conform.nvim`. ByteVim will manage formatting automatically."
      vim.notify(msg:format(key), vim.log.levels.WARN)
      opts[key] = nil
    end
  end

  if opts.format then
    vim.notify("`opts.format` is deprecated. Please use `opts.default_format_opts` instead.", vim.log.levels.WARN)
  end

  require("conform").setup(opts)
end

return {
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    lazy = true,
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ timeout_ms = 3000 })
        end,
        mode = { "n", "v" },
        desc = "Format Buffer",
      },
      {
        "<leader>ctf",
        function()
          M.toggle_format_on_save()
        end,
        desc = "Toggle format on save",
      },
    },
    init = function()
      -- Register the conform formatter with ByteVim's custom logic
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("ByteVimFormat", { clear = true }),
        callback = function()
          if format_on_save_enabled then
            require("conform").format()
          end
        end,
      })
    end,
    opts = function()
      local opts = {
        default_format_opts = {
          timeout_ms = 3000,
          async = false,
          quiet = false,
          lsp_format = "fallback",
        },
        formatters_by_ft = {
          html = { "prettier" },
          htmlangular = { "prettier" },
          htmldjango = { "prettier" },
          lua = { "stylua" },
          fish = { "fish_indent" },
          sh = { "shfmt" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          javascript = { "prettier" },
          python = { "black" },
          markdown = { "markdownfmt" },
          rust = { "rustfmt" },
          toml = { "taplo" },
          svelte = { "prettier" },
          go = { "gofmt" },
          yaml = { "yamlfmt" },
          yml = { "yamlfmt" },
        },
        formatters = {
          injected = { options = { ignore_errors = true } },
        },
      }
      return opts
    end,
    config = M.setup,
  },
}
