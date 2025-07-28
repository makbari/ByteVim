return {
  ["lua_ls"] = {
    settings = {
      Lua = {
        workspace = {
          checkThirdParty = false,
          library = {
            "${3rd}/luv/library",
            unpack(vim.api.nvim_get_runtime_file("", true)),
          },
        },
        completion = { callSnippet = "Replace" },
      },
    },
  },
}