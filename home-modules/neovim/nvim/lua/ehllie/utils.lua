local M = {}

---@generic T
---@param x `T`
---@return `T`
function M.id(x)
  return x
end

---@generic T
---@param x T
---@return fun(): T
function M.const(x)
  return function()
    return x
  end
end

---Given two tables, returns a new table with the values of the second appended to the first
---@param first table
---@param second table
---@return table
function M.concat(first, second)
  local result = { unpack(first) }
  for i = 1, #second do
    result[#result + 1] = second[i]
  end
  return result
end

---@param tab table
---@param key_name string
---@param prefix table
---@return table
function M.prefix_key(tab, key_name, prefix)
  return vim.tbl_deep_extend("force", tab, {
    [key_name] = M.concat(prefix, tab[key_name] or {}),
  })
end

---Returns a table of keys from a table
---@param tab table
---@return table
function M.keys(tab)
  local result = {}
  for k, _ in pairs(tab) do
    table.insert(result, k)
  end
  return result
end

---Transforms tables' key: value pairs using the provided function
---@generic T1
---@generic T2
---@generic T3
---@generic T4
---@param fun fun(k: T1, v: T2): (T3, T4)
---@param tab table<T1, T2>
---@return table<T3, T4>
function M.transform_table(fun, tab)
  local result = {}
  for k, v in pairs(tab) do
    local nk, nv = fun(k, v)
    result[nk] = nv
  end
  return result
end

---Checks whether a table contains a value.
---@param elem any
---@param table table
---@return boolean
function M.is_in(elem, table)
  for _, value in pairs(table) do
    if value == elem then
      return true
    end
  end
  return false
end

---@generic T1
---@generic T2
---@param fun fun(acc: T1, elem: T2): T1
---@param acc T1
---@param tab { [integer]: T2 }}
---@return T1
function M.fold(fun, acc, tab)
  for _, v in ipairs(tab) do
    acc = fun(acc, v)
  end
  return acc
end

---@generic R
---@param funcs table<fun(arg: `T`): `R`>
---@param args table<`T`>
---@return table<`R`>
function M.zip_map(funcs, args)
  local results = {}
  for i, func in ipairs(funcs) do
    results[i] = func(args[i])
  end
  return results
end

---@param lines table<string>
---@param min_width integer?
---@return table<string>
function M.center(lines, min_width)
  local align = require("plenary.strings").align_str
  local max_len = min_width or 0
  for _, line in ipairs(lines) do
    max_len = math.max(max_len, #line)
  end
  local result = {}
  for _, line in ipairs(lines) do
    local diff = max_len - #line
    local left_pad = math.floor(diff / 2)
    result[#result + 1] = align((align(line, #line + left_pad)), max_len, true)
  end
  return result
end

local function nop() end

M.right_ui = {}

---@type {[string]: {open: function, close: function}}
M.right_ui.functions = { closed = { open = nop, close = nop } }

M.right_ui.status = "closed"

M.right_ui.restore = nop

---@param name string
---@param open function
---@param close function
function M.right_ui.register(name, open, close)
  M.right_ui.functions[name] = { open = open, close = close }
end

---@param invoked_from string
---@return nil
function M.right_ui.toggle(invoked_from)
  pcall(M.right_ui.functions[M.right_ui.status].close)
  M.right_ui.restore = nop
  if invoked_from == M.right_ui.status then
    M.right_ui.status = "closed"
  else
    pcall(M.right_ui.functions[invoked_from].open)
    M.right_ui.status = invoked_from
  end
end

---@param invoked_from string
---@return nil
function M.right_ui.temp_open(invoked_from)
  if invoked_from ~= M.right_ui.status then
    local old_status = M.right_ui.status
    M.right_ui.toggle(invoked_from)
    M.right_ui.restore = function()
      M.right_ui.toggle(old_status)
    end
  end
end

local editor_cmd = "neovide ."

---@alias ShellTypes "NoShell" | "Poetry"

---@return ShellTypes
local function find_shell()
  local poetry = io.popen("poetry check", "r")
  if poetry then
    for line in poetry:lines() do
      if line == "All set!" then
        return "Poetry"
      end
    end
  end

  return "NoShell"
end

---@param shell ShellTypes
local function run_shell(shell)
  local cmd = ""
  if shell == "Poetry" then
    cmd = "poetry run " .. editor_cmd
  elseif shell == "NoShell" then
    print("No shell found")
    return
  end
  local proc = io.popen(cmd)
  if proc then
    proc:close()
    vim.cmd("confirm qa")
  end
end

---@param scale integer
---@return {width: integer, height: integer}
function M.ui_dim_fraction(scale)
  local ui = vim.api.nvim_list_uis()[1]
  return {
    width = math.floor(ui.width * scale),
    height = math.floor(ui.height * scale),
  }
end

---Creates a floating window with sane defaults
---@param opts {ratio: float?, bufnr: integer?}
---@return any
function M.floating_win(opts)
  local ui = vim.api.nvim_list_uis()[1]
  local ratio = opts.ratio or 0.7
  local bufnr = opts.bufnr or vim.api.nvim_create_buf(false, true)
  local dims = M.ui_dim_fraction(ratio)
  local row = (ui.height - dims.height) / 2
  local col = (ui.width - dims.width) / 2

  return vim.api.nvim_open_win(bufnr, true, {
    relative = "editor",
    width = dims.width,
    height = dims.height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })
end

function M.to_shell()
  run_shell(find_shell())
end

return M
