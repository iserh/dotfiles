return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    -- Flavour follows vim.o.background, which Neovim flips when Ghostty
    -- reports a system theme change (DEC mode 2031).
    opts = {
      flavour = "auto",
      background = { light = "latte", dark = "frappe" },
    },
  },
  { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin" } },
}
