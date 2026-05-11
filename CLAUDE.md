# ByteVim — Agent guide

Personal Neovim configuration, LazyVim-derived, written in Lua. Bootstrap chain:
`init.lua` → `lua/config/init.lua` → `options` → `lazy` → `keymaps` → `autocmds` → `colorscheme`. The single global seam is `_G.ByteVim`, populated lazily from `lua/utils/` via the metatable in `lua/utils/init.lua`.

## Agent skills

### Issue tracker

Local markdown under `.scratch/<feature>/`. No remote tracker; this is a personal config repo. See `docs/agents/issue-tracker.md`.

### Triage labels

Default vocabulary — `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: `CONTEXT.md` and `docs/adr/` at the repo root. See `docs/agents/domain.md`.
