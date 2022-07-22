local plen_str = require("plenary.strings")

local M = {}

---@generic T
---@param str `T`
---@return `T`
M.id = function(str)
  return str
end

---@param vals table
---@return fun(str: string): string)
M.format = function(vals)
  ---@param str string
  return function(str)
    return string.format(str, unpack(vals))
  end
end

---@generic R
---@param funcs table<fun(arg: `T`): `R`>
---@param args table<`T`>
---@return table<`R`>
M.zip_map = function(funcs, args)
  local results = {}
  for i, func in ipairs(funcs) do
    results[i] = func(args[i])
  end
  return results
end

---@param lines table<string>
---@param min_width integer?
---@return table<string>
M.center = function(lines, min_width)
  local align = plen_str.align_str
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

return M
