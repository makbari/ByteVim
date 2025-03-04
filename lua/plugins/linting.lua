return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      events = { "BufWritePost" }, -- Lint on save
      linters_by_ft = {
        typescript = { "eslint" },
        typescriptreact = { "eslint" },
        deno = { "deno" },
        rust = { "clippy" },
        python = { "flake8" },
        markdown = { "markdownlint" },
        lua = { "luacheck" },
        vue = { "eslint" },
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

      -- Apply custom linter configurations
      for name, linter in pairs(opts.linters) do
        lint.linters[name] = type(lint.linters[name]) == "table"
            and type(linter) == "table"
            and vim.tbl_deep_extend("force", lint.linters[name], linter)
          or linter
      end
      lint.linters_by_ft = opts.linters_by_ft

      -- Debounce function to limit linting frequency
      local function debounce(ms, fn)
        local timer = vim.uv.new_timer()
        return function(...)
          local args = { ... }
          timer:start(ms, 0, function()
            timer:stop()
            vim.schedule_wrap(fn)(unpack(args))
          end)
        end
      end

      -- Check if linter executable exists
      local function is_executable(name)
        return vim.fn.executable(name) == 1
      end

      -- Lint current file
      local function lint_files()
        local names = lint._resolve_linter_by_ft(vim.bo.filetype)
        if #names == 0 then
          names = lint.linters_by_ft["_"] or {}
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

      -- Trigger linting on specified events with debounce
      vim.api.nvim_create_autocmd(opts.events, {
        group = vim.api.nvim_create_augroup("ByteVimLint", { clear = true }),
        callback = debounce(150, lint_files),
      })
    end,
  },
}
