return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- 1. Explicit filetype detection
      vim.filetype.add({
        extension = {
          vue = "vue",
        },
      })

      -- 2. Minimal Volar config
      local lspconfig = require("lspconfig")
      lspconfig.volar.setup({
        cmd = { "vue-language-server", "--stdio" },
        filetypes = { "vue" },
        init_options = {
          typescript = {
            tsdk = vim.fn.stdpath("data") .. "/mason/packages/typescript-language-server/node_modules/typescript/lib",
          },
          vue = {
            hybridMode = false,
          },
        },
        on_new_config = function(new_config)
          new_config.init_options.typescript.tsdk =
            vim.fn.expand("~/.local/share/nvim/mason/packages/typescript-language-server/node_modules/typescript/lib")
        end,
      })
    end,
  },
}
