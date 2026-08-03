-- Install every Mason package LazyVim's config implies, then quit as soon as the
-- last one closes. Run with: nvim --headless -c "luafile ~/.config/nvim/mason-sync.lua"

local pending = 0

-- Armed before anything that can throw. A headless nvim has nothing to return to,
-- so any uncaught error would otherwise leave the bootstrap run hanging forever.
vim.defer_fn(function()
  io.stderr:write("timed out with " .. pending .. " still pending\n")
  vim.cmd("qa!")
end, 300000)

local function main()
  local LazyVim = require("lazyvim.util")

  local pkgs, seen = {}, {}
  local function add(name)
    if name and not seen[name] then
      seen[name] = true
      pkgs[#pkgs + 1] = name
    end
  end

  for _, tool in ipairs((LazyVim.opts("mason.nvim") or {}).ensure_installed or {}) do
    add(tool)
  end

  -- mason-lspconfig v2 dropped the `mappings.server` module in favour of get_mappings().
  -- Try both so the script survives a rollback to an older pin either way.
  local function server_to_package()
    local ok, ml = pcall(require, "mason-lspconfig")
    if ok and type(ml.get_mappings) == "function" then
      return ml.get_mappings().lspconfig_to_package
    end
    local legacy_ok, legacy = pcall(require, "mason-lspconfig.mappings.server")
    if legacy_ok then
      return legacy.lspconfig_to_package
    end
    error("cannot resolve mason-lspconfig's server-to-package mapping")
  end

  local map = server_to_package()
  for server, opts in pairs((LazyVim.opts("nvim-lspconfig") or {}).servers or {}) do
    if opts.enabled ~= false and opts.mason ~= false then
      add(map[server])
    end
  end

  local registry = require("mason-registry")
  local failed = {}

  local function done()
    if #failed > 0 then
      io.stderr:write("failed: " .. table.concat(failed, " ") .. "\n")
    end
    vim.cmd("qa!")
  end

  registry.refresh(function()
    local queued = {}
    for _, name in ipairs(pkgs) do
      local ok, pkg = pcall(registry.get_package, name)
      if ok and not pkg:is_installed() then
        pending = pending + 1
        queued[#queued + 1] = name
        pkg:install():once("closed", function()
          if not pkg:is_installed() then
            failed[#failed + 1] = name
          end
          pending = pending - 1
          if pending == 0 then
            vim.schedule(done)
          end
        end)
      end
    end

    io.stderr:write(#queued == 0 and "nothing to install\n" or ("installing: " .. table.concat(queued, " ") .. "\n"))
    if pending == 0 then
      vim.schedule(done)
    end
  end)
end

local ok, err = pcall(main)
if not ok then
  io.stderr:write("mason-sync failed: " .. tostring(err) .. "\n")
  vim.cmd("qa!")
end
