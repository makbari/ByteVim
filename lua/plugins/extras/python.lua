local lsp = "pyright"
local ruff_server_name = "ruff"

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      opts.servers[ruff_server_name] = vim.tbl_deep_extend("force", opts.servers[ruff_server_name] or {}, {
        mason = false,
        cmd_env = { RUFF_TRACE = "messages" },
        init_options = {
          settings = {
            logLevel = "error",
          },
        },
        keys = {
          {
            "<leader>co",
            ByteVim.lsp.action["source.organizeImports"],
            desc = "Organize Imports",
          },
        },
        on_init = function(client)
          local venv_path = client.config.settings.python.venvPath
          for _, c in ipairs(vim.lsp.get_clients({ name = client.name })) do
            if c.id ~= client.id and (c.config.settings == nil or c.config.settings.python == nil or c.config.settings.python.venvPath ~= venv_path) then
              vim.lsp.stop_client(c.id)
            end
          end
        end,
      })

      opts.servers[lsp] = vim.tbl_deep_extend("force", opts.servers[lsp] or {}, {
        mason = false,
        on_init = function(client)
          local venv_path = client.config.settings.python.venvPath
          for _, c in ipairs(vim.lsp.get_clients({ name = client.name })) do
            if c.id ~= client.id and (c.config.settings == nil or c.config.settings.python == nil or c.config.settings.python.venvPath ~= venv_path) then
              vim.lsp.stop_client(c.id)
            end
          end
        end,
      })

      local enabled_python_lsps = { ruff_server_name, lsp } -- "ruff" and "pyright"

      local python_lsp_candidates = { "ruff", "pyright", "basedpyright", "pylsp", "ruff_lsp" }
      for _, server_candidate in ipairs(python_lsp_candidates) do
        opts.servers[server_candidate] = opts.servers[server_candidate] or {}
        if vim.tbl_contains(enabled_python_lsps, server_candidate) then
          opts.servers[server_candidate].enabled = true
        else
          opts.servers[server_candidate].enabled = false
        end
      end
    end,
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          runner = "pytest",
          python = ".venv/bin/python",
        },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mfussenegger/nvim-dap-python",
      keys = {
        {
          "<leader>dPt",
          function()
            require("dap-python").test_method()
          end,
          desc = "Debug Method",
          ft = "python",
        },
        {
          "<leader>dPc",
          function()
            require("dap-python").test_class()
          end,
          desc = "Debug Class",
          ft = "python",
        },
      },
      config = function()
        require("dap-python").setup("debugpy-adapter")
      end,
    },
  },

  {
    "linux-cultist/venv-selector.nvim",
    cmd = "VenvSelect",
    opts = {
      options = {
        notify_user_on_venv_activation = true,
      },
    },
    ft = "python",
    keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" } },
  },

  {
    "hrsh7th/nvim-cmp",
    optional = true,
    opts = function(_, opts)
      opts.auto_brackets = opts.auto_brackets or {}
      table.insert(opts.auto_brackets, "python")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "ninja", "rst" } },
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "black")
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    optional = true,
    opts = {
      handlers = {
        python = function() end,
      },
    },
  },
}
