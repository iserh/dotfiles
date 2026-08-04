local vault = vim.fn.expand("~/Documents/Obsidian/Default")

-- The community fork rather than epwalsh/obsidian.nvim: upstream's
-- commands/new.lua ignores the buffer handle open_note() hands it and writes to
-- buffer 0, so `:ObsidianNew` from a nomodifiable window (Neo-tree) dies with
-- "Buffer is not 'modifiable'". The fork rewrote that path, and its completion
-- runs as an in-process LSP, so it works with blink.cmp.
return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = true,
  -- Reachable from anywhere — the explorer, another project, an empty buffer.
  -- `legacy_commands = false` collapses the whole surface to one command, so
  -- this is the entire entry point.
  cmd = "Obsidian",
  -- Also attach on the vault's own files, so completion and `gf` are live
  -- without having run a command first. `ft = "markdown"` would instead load it
  -- for every markdown file in every code repo.
  event = {
    "BufReadPre " .. vault .. "/*.md",
    "BufNewFile " .. vault .. "/*.md",
  },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    -- The `:ObsidianFoo` aliases go away in 4.0; use `:Obsidian foo` only.
    legacy_commands = false,
    workspaces = {
      { name = "default", path = vault },
    },
    picker = { name = "fzf-lua" },
    -- render-markdown.nvim (LazyVim's markdown extra) already draws checkboxes,
    -- bullets and conceal. Running both fights over the same extmarks.
    ui = { enable = false },
  },
}
