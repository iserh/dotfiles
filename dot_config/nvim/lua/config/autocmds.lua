-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- conform has no toml formatter, so format-on-save falls through to the taplo LSP, which
-- reformats the whole document to its own 2-space style. Format toml on demand instead.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "toml",
  callback = function()
    vim.b.autoformat = false
  end,
})
