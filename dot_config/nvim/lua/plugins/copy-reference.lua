return {
  "cajames/copy-reference.nvim",
  opts = {},
  cmd = "CopyReference",
  keys = {
    { "yr", "<cmd>CopyReference file<cr>", mode = { "n", "v" }, desc = "Copy file path" },
    { "yrr", "<cmd>CopyReference line<cr>", mode = { "n", "v" }, desc = "Copy file:line reference" },
  },
}
