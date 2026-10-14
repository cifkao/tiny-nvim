-- `:checkhealth config`: reports what this config expects from the machine.
local M = {}

local function check_version()
  vim.health.start "Neovim"
  local version = tostring(vim.version())
  if vim.fn.has "nvim-0.12" == 1 then
    vim.health.ok(version)
  else
    vim.health.error(version .. " is too old; 0.12 or later is required (see README)")
  end
end

local function check_treesitter()
  vim.health.start "Treesitter toolchain (needed to build parsers)"
  for _, req in ipairs(require("utils.treesitter").requirements()) do
    if req.ok then
      vim.health.ok(req.name .. ": " .. req.detail)
    else
      vim.health.error(req.name .. ": " .. req.detail)
    end
  end
end

local function check_tools()
  vim.health.start "Optional tools"
  local tools = {
    { "rg", "grep pickers" },
    { "fd", "file pickers" },
    { "lazygit", "<leader>gg" },
    { "delta", "git diff previews" },
  }
  for _, tool in ipairs(tools) do
    local exe, used_for = tool[1], tool[2]
    if vim.fn.executable(exe) == 1 then
      vim.health.ok(exe .. ": " .. vim.fn.exepath(exe))
    else
      vim.health.warn(exe .. " not found (" .. used_for .. ")")
    end
  end
end

local function check_lsp_servers()
  vim.health.start "LSP servers (lsp/*.lua)"
  local names = {}
  for name, kind in vim.fs.dir(vim.fs.joinpath(vim.fn.stdpath "config", "lsp")) do
    if kind == "file" and name:match "%.lua$" then
      table.insert(names, name:sub(1, -5))
    end
  end
  table.sort(names)
  for _, name in ipairs(names) do
    local cmd = vim.lsp.config[name].cmd
    local exe = type(cmd) == "table" and cmd[1] or nil
    local enabled = vim.lsp.is_enabled(name)
    if not exe then
      vim.health.info(name .. ": custom cmd")
    elseif vim.fn.executable(exe) == 1 then
      vim.health.ok(("%s: %s%s"):format(name, vim.fn.exepath(exe), enabled and "" or " (not enabled)"))
    elseif enabled then
      vim.health.warn(("%s: `%s` not found, the server will not start"):format(name, exe))
    else
      vim.health.info(("%s: `%s` not found (not enabled)"):format(name, exe))
    end
  end
end

function M.check()
  check_version()
  check_treesitter()
  check_tools()
  check_lsp_servers()
end

return M
