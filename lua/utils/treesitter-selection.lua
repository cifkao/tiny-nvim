-- Minimal incremental selection built on the Neovim treesitter API.
-- Replaces the `incremental_selection` module that the archived master branch
-- of nvim-treesitter used to provide.
local M = {}

---@type table<integer, TSNode[]>
local stacks = {}

-- Set while we re-enter visual mode ourselves, so the ModeChanged reset below ignores it.
local selecting = false

local function in_visual_mode()
  return vim.fn.mode():match "^[vV\22]" ~= nil
end

local function select_node(node)
  local srow, scol, erow, ecol = node:range()
  if ecol == 0 and erow > srow then
    -- Exclusive end at column 0: select up to the end of the previous line.
    erow = erow - 1
    ecol = #vim.api.nvim_buf_get_lines(0, erow, erow + 1, true)[1]
  elseif ecol > 0 then
    ecol = ecol - 1
  end
  selecting = true
  if in_visual_mode() then
    vim.cmd "normal! \27" -- leave visual mode; `v` would otherwise toggle it off below
  end
  vim.api.nvim_win_set_cursor(0, { srow + 1, scol })
  vim.cmd "normal! v"
  vim.api.nvim_win_set_cursor(0, { erow + 1, math.max(ecol, 0) })
  selecting = false
end

local function has_parser(buf)
  local ok, parser = pcall(vim.treesitter.get_parser, buf)
  return ok and parser ~= nil
end

function M.init()
  local buf = vim.api.nvim_get_current_buf()
  if not has_parser(buf) then
    return
  end
  local node = vim.treesitter.get_node { bufnr = buf }
  if not node then
    return
  end
  stacks[buf] = { node }
  select_node(node)
end

local function selected_range()
  local _, srow, scol = unpack(vim.fn.getpos "v")
  local _, erow, ecol = unpack(vim.fn.getpos ".")
  if srow > erow or (srow == erow and scol > ecol) then
    srow, scol, erow, ecol = erow, ecol, srow, scol
  end
  return srow - 1, scol - 1, erow - 1, ecol -- end is exclusive
end

function M.increment()
  local buf = vim.api.nvim_get_current_buf()
  local stack = stacks[buf]
  local node
  if stack and #stack > 0 then
    node = stack[#stack]
  else
    local srow, scol, erow, ecol = selected_range()
    node = vim.treesitter.get_node { bufnr = buf, pos = { srow, scol } }
    if node then
      -- Climb until the node covers the current visual selection.
      while node and not vim.treesitter.node_contains(node, { srow, scol, erow, ecol }) do
        node = node:parent()
      end
    end
    stack = node and { node } or {}
    stacks[buf] = stack
  end
  if not node then
    return
  end
  local parent = node:parent()
  -- Skip ancestors with the same range so each step visibly grows the selection.
  while parent and vim.deep_equal({ parent:range() }, { node:range() }) do
    node = parent
    parent = node:parent()
  end
  if parent then
    table.insert(stack, parent)
    select_node(parent)
  else
    select_node(node)
  end
end

function M.decrement()
  local buf = vim.api.nvim_get_current_buf()
  local stack = stacks[buf]
  if not stack or #stack == 0 then
    return
  end
  if #stack > 1 then
    table.remove(stack)
  end
  select_node(stack[#stack])
end

vim.api.nvim_create_autocmd({ "ModeChanged" }, {
  group = vim.api.nvim_create_augroup("treesitter_selection_reset", { clear = true }),
  pattern = "[vV\22]*:*",
  callback = function(ev)
    if not selecting and not in_visual_mode() then
      stacks[ev.buf] = nil
    end
  end,
})

return M
