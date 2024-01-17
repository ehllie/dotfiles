_G.do_auto_format = true
_G.symbols = {
  Namespace = "",
  Package = "",
  Class = "𝓒",
  Method = "",
  Property = "",
  Constructor = "",
  Enum = "ℰ",
  Function = "λ",
  Variable = "",
  Constant = "",
  String = "𝓐",
  Number = "#",
  Boolean = "⊨",
  Array = "",
  Object = "⦿",
  Key = "🔐",
  Null = "",
  EnumMember = "",
  Struct = "𝓢",
  Color = "",
  Event = "",
  Field = "",
  File = "",
  Folder = "",
  Interface = "",
  Keyword = "",
  Module = "",
  Operator = "",
  Reference = "",
  Snippet = "",
  Text = "",
  TypeParameter = "",
  Unit = "",
  Value = "",
  Copilot = "",
}

_G.store = {
  gcc = "@gcc@",
  node = "@nodejs@",
  prettier_svelte = "@prettierSvelte@",
  prettier_toml = "@prettierToml@",
}

local CallQueue = {}
CallQueue.mt = {}
function CallQueue.new()
  local tbl = {
    call = nil,
    func = nil,
    inner = {},
  }
  setmetatable(tbl, CallQueue.mt)
  return tbl
end

function CallQueue.mt.__index(table, key)
  local inner = rawget(table, "inner")
  local val = inner[key]
  if val == nil then
    local queue = CallQueue.new()
    inner[key] = queue
    return queue
  else
    return val
  end
end

function CallQueue.mt.__newindex(table, key, fn)
  local inner = rawget(table, "inner")
  local queue = inner[key]
  if queue == nil then
    queue = CallQueue.new()
    inner[key] = queue
  end
  rawset(queue, "func", fn)
  local call = rawget(queue, "call")
  if call ~= nil then
    fn(unpack(call))
    rawset(queue, "call", nil)
  end
end

function CallQueue.mt.__call(table, ...)
  local func = rawget(table, "func")
  if func == nil then
    rawset(table, "call", { ... })
  else
    func(...)
  end
end

-- For setting up project specific options in exrc
---@type table<function>
_G.reconfigure_plugin = CallQueue.new()

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("ehllie.options")
require("ehllie.autocommands")
-- Plugins configured by files in the lua/ehllie/plugins directory
require("lazy").setup("ehllie.plugins", {
  lockfile = "@repoDir@/lazy-lock.json",
})
require("ehllie.keymaps")

if vim.g.neovide then
  require("ehllie.neovide")
end
