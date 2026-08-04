return {
  "mfussenegger/nvim-lint",
  opts = function(_, opts)
    -- LazyVim's markdown extra registers markdownlint-cli2 here. Drop it so
    -- markdown buffers produce no lint diagnostics.
    opts.linters_by_ft = opts.linters_by_ft or {}
    opts.linters_by_ft.markdown = {}
    opts.linters_by_ft["markdown.mdx"] = {}
    return opts
  end,
}
