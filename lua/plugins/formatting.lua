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
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("ByteVimFormat", { clear = true }),
        callback = function()
          require("conform").format()
        end,
      })
    end,
    opts = {
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
        svelte = { "prettier" },
        vue = { "prettier" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)
    end,
  },
}
