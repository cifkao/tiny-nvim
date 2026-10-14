-- Toolchain for nvim-treesitter (main branch). Parsers are compiled on each
-- machine, which needs the tree-sitter CLI, a C compiler, curl and tar.
-- Nothing else on the machine uses the CLI, so it is downloaded into Neovim's
-- data directory on demand; the rest are prerequisites that are only checked.
local M = {}

-- The CLI only needs to be >= 0.26.1 for nvim-treesitter, but a pinned
-- version keeps parser builds identical across machines. Keep its major.minor
-- in line with the tree-sitter library bundled with Neovim (0.26 for 0.12).
M.cli_version = "0.26.13"
local cli_min_version = { 0, 26, 1 }
local cli_dir = vim.fs.joinpath(vim.fn.stdpath "data", "tree-sitter")
local cli_path = vim.fs.joinpath(cli_dir, "tree-sitter")

---@return vim.Version?
local function cli_version_of(exe)
  if vim.fn.executable(exe) ~= 1 then
    return nil
  end
  local out = vim.fn.system { exe, "--version" }
  return vim.v.shell_error == 0 and vim.version.parse(out) or nil
end

---@return string? path, vim.Version? version
local function find_cli()
  for _, exe in ipairs { "tree-sitter", cli_path } do
    local version = cli_version_of(exe)
    if version and vim.version.ge(version, cli_min_version) then
      return vim.fn.exepath(exe), version
    end
  end
end

-- nvim-treesitter looks the CLI up on PATH.
local function expose_downloaded_cli()
  if not vim.env.PATH:find(cli_dir, 1, true) then
    vim.env.PATH = cli_dir .. ":" .. vim.env.PATH
  end
end

---@return boolean ok, string? err
local function download_cli()
  local os_name = ({ Linux = "linux", OSX = "macos" })[jit.os]
  local arch = ({ x64 = "x64", arm64 = "arm64" })[jit.arch]
  if not os_name or not arch then
    return false, ("no prebuilt tree-sitter CLI for %s/%s"):format(jit.os, jit.arch)
  end
  for _, tool in ipairs { "curl", "gzip" } do
    if vim.fn.executable(tool) ~= 1 then
      return false, tool .. " is needed to download the tree-sitter CLI"
    end
  end
  local url = ("https://github.com/tree-sitter/tree-sitter/releases/download/v%s/tree-sitter-%s-%s.gz"):format(
    M.cli_version,
    os_name,
    arch
  )
  vim.notify("Downloading tree-sitter CLI " .. M.cli_version, vim.log.levels.INFO)
  vim.fn.mkdir(cli_dir, "p")
  local gz = cli_path .. ".gz"
  local r = vim.system({ "curl", "-fsSL", "-o", gz, url }):wait()
  if r.code ~= 0 then
    return false, "download failed: " .. vim.trim(r.stderr)
  end
  r = vim.system({ "gzip", "-df", gz }):wait()
  if r.code ~= 0 then
    return false, "extraction failed: " .. vim.trim(r.stderr)
  end
  vim.uv.fs_chmod(cli_path, 493) -- 0755
  return true
end

---@return boolean ok, string? err
local function ensure_cli()
  if find_cli() then
    return true
  end
  local ok, err = download_cli()
  if not ok then
    return false, err
  end
  expose_downloaded_cli()
  if not find_cli() then
    return false, "downloaded tree-sitter CLI is not runnable"
  end
  return true
end

if vim.fn.executable(cli_path) == 1 then
  expose_downloaded_cli()
end

---@class utils.treesitter.Requirement
---@field name string
---@field ok boolean
---@field detail string

-- Everything nvim-treesitter needs to build parsers. Only inspects the machine.
---@param cli_err? string
---@return utils.treesitter.Requirement[]
function M.requirements(cli_err)
  local reqs = {}
  local cli, cli_version = find_cli()
  table.insert(reqs, {
    name = "tree-sitter CLI",
    ok = cli ~= nil,
    detail = cli and ("%s (%s)"):format(tostring(cli_version), cli)
      or cli_err
      or ("not found; downloaded on demand to " .. cli_dir),
  })
  local cc = vim.env.CC
  for _, exe in ipairs { "cc", "gcc", "clang" } do
    if cc then
      break
    end
    if vim.fn.executable(exe) == 1 then
      cc = vim.fn.exepath(exe)
    end
  end
  table.insert(reqs, {
    name = "C compiler",
    ok = cc ~= nil,
    detail = cc or "install Xcode Command Line Tools (macOS) or gcc (Linux)",
  })
  for _, exe in ipairs { "curl", "tar" } do
    local found = vim.fn.executable(exe) == 1
    table.insert(reqs, { name = exe, ok = found, detail = found and vim.fn.exepath(exe) or "not found" })
  end
  return reqs
end

---@return boolean
local function ensure_toolchain()
  local _, cli_err = ensure_cli()
  local missing = vim.tbl_filter(function(req)
    return not req.ok
  end, M.requirements(cli_err))
  if #missing == 0 then
    return true
  end
  local lines = { "Cannot build treesitter parsers, missing requirements:" }
  for _, req in ipairs(missing) do
    table.insert(lines, ("- %s: %s"):format(req.name, req.detail))
  end
  table.insert(lines, "See `:checkhealth config`.")
  vim.notify(table.concat(lines, "\n"), vim.log.levels.ERROR, { title = "treesitter" })
  return false
end

-- Builds run in the background in a UI session; a headless session (plugin
-- bootstrap) waits so that the parsers exist when it exits.
local function wait_if_headless(task)
  if #vim.api.nvim_list_uis() == 0 then
    task:wait(600000)
  end
end

---@param langs string[]
function M.install(langs)
  if #langs == 0 or not ensure_toolchain() then
    return
  end
  wait_if_headless(require("nvim-treesitter").install(langs, { summary = true }))
end

-- Rebuilds installed parsers whose pinned revision changed (lazy.nvim build hook).
function M.update()
  if not ensure_toolchain() then
    return
  end
  wait_if_headless(require("nvim-treesitter").update(nil, { summary = true }))
end

return M
