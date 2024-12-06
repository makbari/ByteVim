local M = {}

---@param opts conform.setupOpts
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
    },
    init = function()
      -- Register the conform formatter with ByteVim's custom logic
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("ByteVimFormat", { clear = true }),
        callback = function()
          require("conform").format()
        end,
      })
    end,
    opts = function()
      ---@type conform.setupOpts
      local opts = {
        default_format_opts = {
          timeout_ms = 3000,
          async = false,
          quiet = false,
          lsp_format = "fallback",
        },
        formatters_by_ft = {
          lua = { "stylua" },
          fish = { "fish_indent" },
          sh = { "shfmt" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          javascript = { "prettier" },
          python = { "black" },
          markdown = { "prettier" },
          rust = { "rustfmt" },
          toml = { "taplo" },
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
