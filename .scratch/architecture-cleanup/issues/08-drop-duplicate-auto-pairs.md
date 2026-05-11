# 08 — Drop the duplicate `jiangmiao/auto-pairs` plugin

Status: ready-for-agent

## Files

- `lua/plugins/coding.lua` lines 62–67 (`echasnovski/mini.pairs`, lazy on `VeryLazy`)
- `lua/plugins/coding.lua` line 68 (`jiangmiao/auto-pairs`, **no lazy spec — eager load**)

## Problem

Two auto-pairs plugins are enabled simultaneously:

```lua
-- coding.lua:62
{
  "echasnovski/mini.pairs",
  event = "VeryLazy",
  opts = { modes = { insert = true, command = true, terminal = false } },
},
{ "jiangmiao/auto-pairs" },
```

`mini.pairs` is configured (and documented in `readme.md`). `jiangmiao/auto-pairs` is unconfigured and has no `event`/`cmd`/`ft`/`keys` so lazy.nvim loads it eagerly at startup. Both plugins install insert-mode keymaps for `(`, `[`, `{`, `"`, `'`, etc. — they fight at insert time, and which one wins depends on load order.

## Solution

Delete line 68 of `lua/plugins/coding.lua`:

```lua
{ "jiangmiao/auto-pairs" },
```

That's the entire fix.

## Acceptance criteria

- The line is removed
- After a restart, `mini.pairs` behavior (documented in `readme.md` under "Coding Keymaps") still works
- Startup is marginally faster (one fewer eager-loaded plugin)

## Deletion test

Pure win. Deleting → no impact, since `mini.pairs` already covers it.
