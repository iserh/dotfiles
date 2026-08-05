-- Directories the pickers never walk. ripgrep and fd already honour .gitignore;
-- these cover the same dirs in repos that don't ignore them and outside git entirely.
local exclude = {
  ".git",
  ".jj",
  "node_modules",
  ".venv",
  "venv",
  "__pycache__",
  ".mypy_cache",
  ".pytest_cache",
  ".ruff_cache",
  ".tox",
  "dist",
  "build",
  "target",
  ".next",
}

local function flags(fmt)
  return table.concat(vim.tbl_map(function(dir)
    return fmt:format(dir)
  end, exclude), " ")
end

return {
  "ibhagwan/fzf-lua",
  opts = function(_, opts)
    local defaults = require("fzf-lua").config.defaults
    local rg_globs, fd_excludes = flags("--glob=!%s"), flags("--exclude=%s")

    opts.files = vim.tbl_extend("force", opts.files or {}, {
      rg_opts = defaults.files.rg_opts .. " " .. rg_globs,
      fd_opts = defaults.files.fd_opts .. " " .. fd_excludes,
    })
    -- grep's rg_opts must keep `-e` last, so the globs go in front of it.
    opts.grep = vim.tbl_extend("force", opts.grep or {}, {
      rg_opts = rg_globs .. " " .. defaults.grep.rg_opts,
    })
    return opts
  end,
}
