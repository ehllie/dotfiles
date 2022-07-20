---@type table<{mappings: table, opts: table?}>
vim.g.do_auto_format = true

require("user.options")
require("user.plugins")
require("user.autocommands")
require("user.keymaps")
