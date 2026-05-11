# 09 — `coding.lua` hard-depends on the `tailwindcss` filetype pack

Status: ready-for-agent

## Files

- `lua/plugins/coding.lua` lines 43–52 (nvim-cmp `format` function)
- `lua/plugins/extras/tailwindcss.lua` (only place `tailwind-tools` is installed)

## Problem

`lua/plugins/coding.lua:48` does:

```lua
formatting = {
  format = function(entry, item)
    local icons = require("config.icons").kind
    if icons[item.kind] then
      item.kind = icons[item.kind] .. " " .. item.kind
    end
    require("lspkind").cmp_format({
      before = require("tailwind-tools.cmp").lspkind_format,
    })
    return item
  end,
},
```

Two issues:

1. **Hidden coupling.** `tailwind-tools` is only installed via `extras/tailwindcss.lua`. If a user doesn't import that extras pack (or disables it), the `require("tailwind-tools.cmp")` throws on first cmp completion. Filetype packs should be optional — they aren't here.
2. **Apparent dead code.** `lspkind.cmp_format({...})` returns a *formatter function*. The code calls it for what looks like a side effect, then returns the original `item`. The lspkind call has no effect on the returned `item`. Looks like a paste error.

## Solutions

Three viable options, pick one:

### (a) Defensive guard — minimum-effort fix

```lua
formatting = {
  format = function(entry, item)
    local icons = require("config.icons").kind
    if icons[item.kind] then
      item.kind = icons[item.kind] .. " " .. item.kind
    end
    local ok, tw = pcall(require, "tailwind-tools.cmp")
    if ok then
      item = require("lspkind").cmp_format({ before = tw.lspkind_format })(entry, item)
    end
    return item
  end,
},
```

Decouples `coding.lua` from tailwind extras AND fixes the dead-code bug. **Recommended.**

### (b) Move the integration into the extras pack

Have `extras/tailwindcss.lua` extend `nvim-cmp`'s opts:

```lua
{
  "hrsh7th/nvim-cmp",
  optional = true,
  opts = function(_, opts)
    opts.formatting = opts.formatting or {}
    local prev_format = opts.formatting.format
    opts.formatting.format = function(entry, item)
      item = prev_format and prev_format(entry, item) or item
      return require("lspkind").cmp_format({
        before = require("tailwind-tools.cmp").lspkind_format,
      })(entry, item)
    end
  end,
},
```

Cleaner architecturally; the dependency is now where the producing plugin lives. But the chained `format` is fiddly to get right.

### (c) Drop the tailwind cmp integration entirely

If the side effect isn't visibly improving completion items today (and the code suggests it might not be), just remove the `require("tailwind-tools.cmp")` line. Tailwind class autocomplete via `tailwindcss` LSP still works — this was only customising the cmp display format.

## Recommendation

(a). Smallest diff, fixes the bug, removes the coupling. Move to (b) if you accept issue #02 (the `bytevim.lang.define` helper).

## Acceptance criteria

- `coding.lua` no longer fails when the tailwindcss extras pack is disabled (test: comment out `{ import = "plugins.extras.tailwindcss" }` in `lazy.lua` and verify cmp still works in a TypeScript file)
- The lspkind formatter return value is actually applied (or the call is removed entirely)

## Why this matters

Filetype packs should be droppable without breaking core editing. Right now `coding.lua` hard-imports `tailwind-tools.cmp` and `extras/tailwindcss.lua` is silently load-bearing.
