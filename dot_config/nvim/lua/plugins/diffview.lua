return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen origin/main...HEAD<cr>", desc = "Diff vs origin/main" },
    { "<leader>gD", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
  },
}
