return {
  {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    opts = {
      events = { "BufWritePost" }, -- Only lint on save
      linters_by_ft = {
        typescript = { "eslint" },
        typescriptreact = { "eslint" },
        deno = { "deno" },
        rust = { "clippy" },
        python = { "flake8" },
        markdown = { "markdownlint" },
        lua = { "luacheck" },
        go = { "golangcilint" }, -- Add this
      },
      linters = {
        eslint = {
          condition = function(ctx)
            return vim.fs.find({ ".eslintrc.js", ".eslintrc.json", ".eslintrc" }, { path = ctx.dirname, upward = true })[1]
          end,
        },
        luacheck = {
          args = { "--formatter", "plain", "--codes", "-", "--globals", "vim" },
          stdin = true,
        },
      },
    },
    config = function(_, opts)
      local lint = require("lint")

      -- Extend existing linters
      for name, linter in pairs(opts.linters) do
        if type(linter) == "table" and type(lint.linters[name]) == "table" then
          lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
        else
          lint.linters[name] = linter
        end
      end
      lint.linters_by_ft = opts.linters_by_ft

      local function debounce(ms, fn)
        local timer = vim.uv.new_timer()
        return function(...)
          local argv = { ... }
          timer:start(ms, 0, function()
            timer:stop()
            vim.schedule_wrap(fn)(unpack(argv))
          end)
        end
      end

      -- Check if a linter executable exists
      local function is_executable(name)
        return vim.fn.executable(name) == 1
      end

      -- Custom linting logic
      local function lint_files()
        local names = lint._resolve_linter_by_ft(vim.bo.filetype)
        names = vim.list_extend({}, names) -- Copy table
        if #names == 0 then
          vim.list_extend(names, lint.linters_by_ft["_"] or {})
        end
        vim.list_extend(names, lint.linters_by_ft["*"] or {})

        local ctx = { filename = vim.api.nvim_buf_get_name(0) }
        ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
        names = vim.tbl_filter(function(name)
          local linter = lint.linters[name]
          return linter
            and is_executable(linter.command or name)
            and not (linter.condition and not linter.condition(ctx))
        end, names)

        if #names > 0 then
          lint.try_lint(names)
        end
      end

      -- Set up autocommands to trigger linting
      vim.api.nvim_create_autocmd(opts.events, {
        group = vim.api.nvim_create_augroup("ByteVimLint", { clear = true }),
        callback = debounce(150, lint_files),
      })
    end,
  },
}
