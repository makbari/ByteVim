# 02 — Introduce `ByteVim.lang.define` to collapse filetype-pack boilerplate

Status: wontfix

## Decision (2026-05-11)

Deferred. The set of supported languages is stable; the duplication is tolerable. Revisit if the extras count starts growing or if a third filetype pack copies the same pattern verbatim.

## Files

- All of `lua/plugins/extras/*.lua` (~17 files)
- New: `lua/utils/lang.lua`

## Problem

Filetype packs repeat the same three-block dance:

1. `nvim-treesitter` opts → `vim.list_extend(opts.ensure_installed, {...})`
2. `mason-lspconfig.nvim` opts → `vim.list_extend(opts.ensure_installed, {...})`
3. `nvim-lspconfig` opts → register `opts.servers.<name> = {...}`

`extras/deno.lua`, `extras/typescript.lua`, `extras/react.lua`, `extras/angular.lua`, `extras/vue.lua`, `extras/docker.lua` all follow it nearly verbatim. The pattern is enforced by convention, not by code. Copy-paste drift is the failure mode (already happened — see issue #06 and the typescript/react duplication).

## Proposed solution

Introduce a `ByteVim.lang` helper that returns a list of plugin specs from a declarative table:

```lua
-- lua/plugins/extras/typescript.lua
return ByteVim.lang.define({
  filetype = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  treesitter = { "typescript", "tsx", "javascript" },
  mason = { "vtsls" },
  lsp = {
    vtsls = {
      filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
      settings = { ... },
      on_attach = function(client, bufnr) ... end,
    },
  },
})
```

## Open questions (need maintainer input)

1. **Is the boilerplate stable enough to abstract?** Some packs (rust, go) have extra plugins beyond the three-block dance. The helper needs an escape hatch (`plugins = {...}` passthrough) — fine, but it nudges toward "do everything the helper can do" instead of just adding a plain spec when needed.
2. **Is the file count growing?** If you've stopped adding languages, this abstraction has no future callers and the duplication is tolerable.
3. **Worth the cost of one more thing to learn?** The current pattern is googleable; `ByteVim.lang.define` is repo-specific.

## Deletion test

Define the helper, rewrite all 17 extras → each shrinks from ~30 lines of imperative `opts = function...` chaining to ~10 lines of data. Complexity concentrates in `lua/utils/lang.lua`. If `lang.lua` itself becomes ~80 lines covering all three blocks + the passthrough, the helper is earning its keep.

## Acceptance criteria (if accepted)

- `lua/utils/lang.lua` defines `M.define(spec) → list-of-plugin-specs`
- At least three filetype packs are converted (suggest: `deno`, `typescript`, `docker`)
- Behavior is byte-identical: same parsers installed, same servers attached, same keymaps
- Mention the helper in `CONTEXT.md` under "Plugin organisation"

## Recommendation

Decide before implementing. If you're not actively adding languages, defer this issue.
