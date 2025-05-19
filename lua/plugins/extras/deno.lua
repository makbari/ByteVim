return {
  denols = {
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    root_dir = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc"),
    settings = {
      deno = {
        enable = true,
        lint = true,
        unstable = false,
        suggest = {
          imports = {
            hosts = {
              ["https://deno.land"] = true,
            },
          },
        },
      },
    },
  },
}