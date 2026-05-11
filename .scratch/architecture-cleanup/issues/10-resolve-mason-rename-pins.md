# 10 — Resolve the `mason-org/*` vs `williamboman/*` rename pins

Status: completed (2026-05-11)

Migrated all `williamboman/mason*` references to `mason-org/*` across `lspconfig.lua`, `dap.lua`, and every filetype pack in `extras/`. Removed the duplicate `mason-org/*` specs at the bottom of `lspconfig.lua`; `version = "^1.0.0"` pin moved onto the canonical specs.

## Files

- `lua/plugins/lspconfig.lua` lines 3–34 (uses `williamboman/mason.nvim` and `williamboman/mason-lspconfig.nvim`)
- `lua/plugins/lspconfig.lua` lines 252–253 (also pins `mason-org/mason.nvim` and `mason-org/mason-lspconfig.nvim` at `^1.0.0`)

## Problem

`mason.nvim` and `mason-lspconfig.nvim` were transferred from the `williamboman/*` GitHub org to `mason-org/*` in 2025. GitHub auto-redirects the old URLs, so cloning either works.

This config pins **both** names:

```lua
-- lspconfig.lua:3
{ "williamboman/mason.nvim", cmd = "Mason", ... },
-- lspconfig.lua:36
{ "williamboman/mason-lspconfig.nvim", ... },
-- lspconfig.lua:252
{ "mason-org/mason.nvim", version = "^1.0.0" },
{ "mason-org/mason-lspconfig.nvim", version = "^1.0.0" },
```

How `lazy.nvim` resolves this is not obvious:

- It might treat them as two distinct specs and clone twice (likely → duplicate installs, the version pin on `mason-org/*` may not actually apply to the `williamboman/*` clone)
- Or it might dedupe via the GitHub redirect and merge specs — but the merge precedence is unclear, so the version pin might or might not stick

Either way, the intent is ambiguous, and future Mason updates may surprise the user.

## Solutions

Pick one canonical set of names:

### (a) Migrate to `mason-org/*` everywhere

```lua
{ "mason-org/mason.nvim", version = "^1.0.0", cmd = "Mason", ... },
{ "mason-org/mason-lspconfig.nvim", version = "^1.0.0", ... },
```

Delete the `williamboman/*` references. This is the upstream-blessed direction.

### (b) Keep `williamboman/*` aliases

Delete the `mason-org/*` pins at lines 252–253. The `williamboman/*` names will continue to redirect.

## Open questions (need maintainer input)

1. Do you remember why both got added? (Likely: the rename happened during an unrelated edit and the old pins weren't removed.)
2. Are you on Mason v1.x or v2.x? The `^1.0.0` pin says v1; if you've moved to v2 the constraint is wrong.

## Recommendation

(a). The redirect won't last forever; future-proof by using the new org name. Pin to `^1` if you want to stay on Mason v1, or remove the version constraint if you want latest.

## Acceptance criteria

- Exactly one `mason.nvim` spec and one `mason-lspconfig.nvim` spec, both under the same GitHub org
- Version pin is intentional and documented (in the spec comment, not just here)
- `:Lazy` shows a single instance of each, not two

Awaiting decision before this can move to `ready-for-agent`.
