# 07 — Consolidate git plugin specs and resolve `<leader>g*` collisions

Status: completed (2026-05-11)

git-blame moved into `plugins/git.lua` (done as part of Batch C). Keymap re-namespace applied with the scheme below: `<leader>gh*` gitsigns, `<leader>gb*` blame, `<leader>gf*` fzf-lua git, `<leader>go*` octo, `<leader>gl` lazygit, `<leader>gd` diffview. `readme.md` updated.

## Files

- `lua/plugins/git.lua` (lazygit, gitsigns, diffview, git-conflict, octo)
- `lua/plugins/editor.lua` lines 133–173 (git-blame.nvim)
- `lua/plugins/extras/gitlab.lua` (gitlab.nvim — leave; it's a filetype-pack-like extension)

## Problem

**Scattered specs.** "The git plugins" live in three places. Anyone asking "where is the git-blame keymap defined?" has to grep three files.

**Keymap collisions.** Documented in `readme.md` but not enforced anywhere:

| Keymap | Definitions |
|---|---|
| `<leader>gs` | gitsigns "Stage Buffer" (`git.lua:40`) + git-blame "Copy SHA" (`editor.lua:160`) + fzf-lua "Git Status" (`editor.lua:385`) |
| `<leader>gc` | git-blame "Copy Commit URL" (`editor.lua:142`) + fzf-lua "Git Commits" (`editor.lua:392`) |
| `<leader>gB` | git-blame "Open Commit URL" (`editor.lua:136`) + fzf-lua "Git Buffer Commits" (`editor.lua:394`) |
| `<leader>gt` | git-blame "Toggle Blame" (`editor.lua:161`) + treesitter (the README claims this — verify) |

Last spec evaluated wins. Whichever plugin loads last silently captures the keymap.

## Solution

### Step 1 — Consolidate

Move `git-blame.nvim` (`editor.lua:133–173`) into `lua/plugins/git.lua`. This depends on issue #01 being done (or can be done first as a no-op move).

### Step 2 — Re-namespace `<leader>g*`

Propose a clear sub-namespace per concern:

| Prefix | Owner | Examples |
|---|---|---|
| `<leader>gh*` | gitsigns hunks | `<leader>ghs` stage, `<leader>ghr` reset, etc. (already) |
| `<leader>gb*` | git-blame | `<leader>gbo` open commit url, `<leader>gbc` copy commit url, `<leader>gbs` copy SHA, `<leader>gbt` toggle blame |
| `<leader>gf*` | fzf-lua git pickers | `<leader>gfs` git status, `<leader>gfc` commits, `<leader>gfb` branches, `<leader>gfB` buffer commits |
| `<leader>go*` | octo.nvim | `<leader>goi` issues, `<leader>gop` PRs (rename from current `<leader>gi`/`<leader>gp`) |
| `<leader>gl*` | lazygit | `<leader>glg` open (rename from `<leader>lg`) |
| `<leader>gdf` | diffview | (rename from `<leader>dfv`) |

This is one possible scheme. The maintainer should decide.

### Step 3 — Update `readme.md`

The keymap inventory in `readme.md` needs to reflect the new bindings.

## Open questions (need maintainer input)

1. Do you want to keep some of the current bindings (e.g. `<leader>gs` for "Stage Buffer") because muscle memory? If so, which?
2. Is the proposed sub-namespacing acceptable, or do you prefer a different scheme?

## Acceptance criteria

- All git plugin specs live in `lua/plugins/git.lua`
- No `<leader>g*` keymap is defined in two places
- `readme.md`'s git keymap section is updated and accurate
- Optionally: add a small startup check that warns on duplicate keymap registrations (could be a follow-up issue)

## Why this is a deepening

Locality: one file owns the git concern. Correctness: documented keymaps actually fire. Leverage: when you add a new git plugin, you know where it goes.
