-- Install every Mason package LazyVim's config implies, then quit as soon as the
-- last one closes. Run with: nvim --headless -c "luafile ~/.config/nvim/mason-sync.lua"
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

local map = require("mason-lspconfig.mappings.server").lspconfig_to_package
for server, opts in pairs((LazyVim.opts("nvim-lspconfig") or {}).servers or {}) do
  if opts.enabled ~= false and opts.mason ~= false then
    add(map[server])
  end
end

local registry = require("mason-registry")
local pending, failed = 0, {}

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

-- Backstop: never hang a bootstrap run on a wedged download.
vim.defer_fn(function()
  io.stderr:write("timed out with " .. pending .. " still pending\n")
  vim.cmd("qa!")
end, 300000)
