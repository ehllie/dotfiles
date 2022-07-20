require("user.options")
require("user.keymaps")
require("user.plugins")
require("user.autocommands")

-- I can probably use packer's functinality to do this
-- That might imporve startup time as well

local function setup_plugin(config_module)
  local returned_configs = nil

  local deps = {}
  local declare_type = type(config_module.deps)

  if declare_type == "table" then
    for _, dep_name in pairs(config_module.deps) do
      local ok, dep = pcall(require, dep_name)
      if not ok then
        return
      end
      table.insert(deps, dep)
    end
    returned_configs = config_module.setup(unpack(deps))
  elseif declare_type == "string" then
    local ok, dep = pcall(require, config_module.deps)
    if not ok then
      return
    end
    returned_configs = config_module.setup(dep)
  end

  if returned_configs then
    for _, nested in pairs(returned_configs) do
      setup_plugin(nested)
    end
  end
end

-- setup_plugin(require("user.alpha"))
-- setup_plugin(require("user.bufferline"))
-- setup_plugin(require("user.cmp"))
-- setup_plugin(require("user.comment"))
-- setup_plugin(require("user.dap"))
-- setup_plugin(require("user.formatter"))
-- setup_plugin(require("user.hop"))
setup_plugin(require("user.lsp"))
-- setup_plugin(require("user.lualine"))
-- setup_plugin(require("user.nvim-tree"))
-- setup_plugin(require("user.presence"))
-- setup_plugin(require("user.telescope"))
-- setup_plugin(require("user.toggleterm"))
-- setup_plugin(require("user.treesitter"))
-- setup_plugin(require("user.which-key"))
-- setup_plugin(require("user.misc"))
