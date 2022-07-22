require("impatient")

_G.do_auto_format = true

---@type {[string]: {mappings: table, opts: table?}}
_G.plugin_keybinds = {}

require("options")
require("plug-conf")
require("autocommands")
require("keymaps")
