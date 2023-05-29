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

require("options")
require("plug-conf")
require("autocommands")
require("keymaps")

if vim.g.neovide then
  require("neovide")
end
