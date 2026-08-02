return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          -- Without an explicit interpreter pyright resolves imports against the
          -- system python, so nothing installed in the project venv is navigable.
          -- Mutating settings in place is what reaches the server: Neovim sends
          -- client.settings in the didChangeConfiguration that follows on_init.
          on_init = function(client)
            local root = client.config.root_dir or vim.fn.getcwd()

            for _, venv in ipairs({ root .. "/.venv", vim.env.VIRTUAL_ENV }) do
              local python = venv and (venv .. "/bin/python")
              if python and vim.uv.fs_stat(python) then
                client.settings.python = vim.tbl_deep_extend("force", client.settings.python or {}, {
                  pythonPath = python,
                })
                return
              end
            end
          end,
        },
      },
    },
  },
}
