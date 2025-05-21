return {
  {
    "Saecki/crates.nvim",
    tag = "stable",
    event = { "BufRead Cargo.toml" },
    ft = { "rust", "toml" },
    opts = {
      completion = {
        cmp = {
          enabled = true,
          use_custom_kind = true,
          kind_text = {
            version = "Version",
            feature = "Feature",
          },
          kind_highlight = {
            version = "CmpItemKindVersion",
            feature = "CmpItemKindFeature",
          },
        },
        crates = {
          enabled = true,
          min_chars = 3,
          max_results = 8,
        },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
      keys = {
        hide = { "q", "<esc>" },
        open_url = { "<cr>" },
        select = { "<cr>" },
        select_alt = { "s" },
        toggle_feature = { "<cr>" },
        copy_value = { "yy" },
        goto_item = { "gd", "K", "<C-LeftMouse>" },
        jump_forward = { "<c-i>" },
        jump_back = { "<c-o>", "<C-RightMouse>" },
      },
    },
    config = function(_, opts)
      local crates = require("crates")
      crates.setup(opts)
      crates.show()
      local function map(mode, keys, func, desc)
        vim.keymap.set(mode, keys, func, { silent = true, desc = desc })
      end

      -- General
      map("n", "<leader>ct", crates.toggle, "Toggle Crates.nvim")
      map("n", "<leader>cr", crates.reload, "Reload Crates.nvim")

      -- Popups
      map("n", "<leader>cv", crates.show_versions_popup, "Show crate versions")
      map("n", "<leader>cF", crates.show_features_popup, "Show crate features")
      map("n", "<leader>cd", crates.show_dependencies_popup, "Show crate dependencies")

      -- Updates
      map("n", "<leader>cu", crates.update_crate, "Update crate under cursor")
      map("v", "<leader>cu", crates.update_crates, "Update selected crates")
      map("n", "<leader>ca", crates.update_all_crates, "Update all crates")
      map("n", "<leader>cU", crates.upgrade_crate, "Upgrade crate under cursor")
      map("v", "<leader>cU", crates.upgrade_crates, "Upgrade selected crates")
      map("n", "<leader>cA", crates.upgrade_all_crates, "Upgrade all crates")

      -- Table Conversions
      map("n", "<leader>cx", crates.expand_plain_crate_to_inline_table, "Expand crate to inline table")
      map("n", "<leader>cX", crates.extract_crate_into_table, "Extract crate from inline table")

      -- External Links
      map("n", "<leader>cH", crates.open_homepage, "Open crate homepage")
      map("n", "<leader>cR", crates.open_repository, "Open crate repository")
      map("n", "<leader>cD", crates.open_documentation, "Open crate documentation")
      map("n", "<leader>cC", crates.open_crates_io, "Open crate on crates.io")
      map("n", "<leader>cL", crates.open_lib_rs, "Open crate on lib.rs")
    end,
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
    opts = {
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<leader>cR", function()
            vim.cmd.RustLsp("codeAction")
          end, { desc = "Code Action", buffer = bufnr })
          vim.keymap.set("n", "<leader>dr", function()
            vim.cmd.RustLsp("debuggables")
          end, { desc = "Rust Debuggables", buffer = bufnr })
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            -- Add clippy lints for Rust.
            checkOnSave = true,
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    end,
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      vim.list_extend(opts.adapters, {
        require("rustaceanvim.neotest"),
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bacon_ls = {
          enabled = diagnostics == "bacon-ls",
        },
        rust_analyzer = { enabled = false },
      },
    },
  },
}
