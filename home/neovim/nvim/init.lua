pcall(require, "impatient")

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
