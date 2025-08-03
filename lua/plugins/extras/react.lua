return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "typescript", "tsx", "javascript" })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "vtsls" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.vtsls = opts.servers.vtsls or {}
      opts.servers.vtsls.filetypes = vim.list_extend(
        opts.servers.vtsls.filetypes or { "typescript", "javascript" },
        { "typescriptreact", "javascriptreact" }
      )
      opts.servers.vtsls.on_attach = function(client, bufnr)
        if ByteVim.lsp.deno_config_exist() then
          client.stop()
        end
        local function map(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
        end
        map("<leader>co", ByteVim.lsp.action["source.organizeImports"], "Organize Imports")
        map("<leader>cM", ByteVim.lsp.action["source.addMissingImports.ts"], "Add missing imports")
        map("<leader>cu", ByteVim.lsp.action["source.removeUnused.ts"], "Remove unused imports")
        map("<leader>cD", ByteVim.lsp.action["source.fixAll.ts"], "Fix all diagnostics")
      end
    end,
  },
}
