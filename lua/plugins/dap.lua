return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          table.insert(opts.ensure_installed, "js-debug-adapter")
        end,
      },
    },
    opts = function()
      local dap = require("dap")
      -- Adapter for Node.js
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = {
            vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
            "${port}",
          },
        },
      }
      local js_configs = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
          resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Debug Jest Tests",
          runtimeArgs = {
            "./node_modules/jest/bin/jest.js",
            "--inspect-brk",
            "${file}",
            "--runInBand",
          },
          runtimeExecutable = "node",
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
          cwd = "${workspaceFolder}",
          resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Debug All Jest Tests",
          runtimeArgs = {
            "./node_modules/jest/bin/jest.js",
            "--inspect-brk",
            "--runInBand",
          },
          runtimeExecutable = "node",
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
          cwd = "${workspaceFolder}",
          resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
        },
      }
      dap.configurations.javascript = js_configs
      dap.configurations.typescript = js_configs
      dap.configurations.typescriptreact = js_configs
      dap.configurations.javascriptreact = js_configs
    end,
    config = function()
      local dap = require("dap")
      -- Keymaps for DAP
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Debug: Set Conditional Breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug: Continue" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Debug: Step Into" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Debug: Step Over" })
      vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Debug: Step Out" })
      vim.keymap.set("n", "<leader>dd", function()
        local configs = {}
        local seen = {}
        for ft, confs in pairs(dap.configurations) do
          for _, conf in ipairs(confs) do
            if not seen[conf.name] then
              table.insert(configs, { name = conf.name, config = conf })
              seen[conf.name] = true
            end
          end
        end
        vim.ui.select(configs, {
          prompt = "Select DAP configuration:",
          format_item = function(item)
            return item.name
          end,
        }, function(choice)
          if choice then
            dap.run(choice.config)
          end
        end)
      end, { desc = "Debug: Select Configuration" })
      vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Debug: Run Last" })
      vim.keymap.set("n", "<leader>dt", function()
        require("dap").terminate()
      end, { desc = "Debug: Terminate" })
      vim.keymap.set({ "n", "v" }, "<leader>de", function()
        require("dapui").eval()
      end, { desc = "Debug: Evaluate expression/selection" })
      -- REPL keymap for interactive console
      vim.keymap.set("n", "<leader>dr", function()
        require("dap").repl.open()
      end, { desc = "Debug: Open REPL Console" })
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dapui = require("dapui")
      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 }, -- Emphasize REPL for console
              { id = "console", size = 0.5 },
            },
            size = 10,
            position = "bottom",
          },
        },
      })
      local dap = require("dap")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
