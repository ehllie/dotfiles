local function config() end

return {
  "simrat39/symbols-outline.nvim",
  config = function(_, opts)
    require("symbols-outline").setup(opts)
    local ui_funcs = require("ehllie.utils").right_ui
    ui_funcs.register("symbols", function()
      vim.cmd("SymbolsOutlineOpen")
    end, function()
      vim.cmd("SymbolsOutlineClose")
    end)

    local function toggle()
      ui_funcs.toggle("symbols")
    end

    require("which-key").register({ ["<leader>o"] = { toggle, "Toggle outline" } })
  end,
  opts = {
    highlight_hovered_item = true,
    show_guides = true,
    auto_preview = false,
    position = "right",
    relative_width = true,
    width = 20,
    auto_close = false,
    show_numbers = false,
    show_relative_numbers = false,
    -- show_symbol_details = true,
    preview_bg_highlight = "Pmenu",
    keymaps = { -- These keymaps can be a string or a table for multiple keys
      close = {},
      goto_location = "<Cr>",
      focus_location = "o",
      hover_symbol = "K",
      toggle_preview = "PP",
      rename_symbol = "r",
      code_actions = "a",
      fold = "h",
      unfold = "l",
      fold_all = "H",
      unfold_all = "L",
    },
    lsp_blacklist = {},
    symbol_blacklist = {},
    symbols = {
      File = { icon = symbols.File, hl = "TSURI" },
      Module = { icon = symbols.Module, hl = "TSNamespace" },
      Namespace = { icon = symbols.Namespace, hl = "TSNamespace" },
      Package = { icon = symbols.Package, hl = "TSNamespace" },
      Class = { icon = symbols.Class, hl = "TSType" },
      Method = { icon = symbols.Method, hl = "TSMethod" },
      Property = { icon = symbols.Property, hl = "TSMethod" },
      Field = { icon = symbols.Field, hl = "TSField" },
      Constructor = { icon = symbols.Constructor, hl = "TSConstructor" },
      Enum = { icon = symbols.Enum, hl = "TSType" },
      Interface = { icon = symbols.Interface, hl = "TSType" },
      Function = { icon = symbols.Function, hl = "TSFunction" },
      Variable = { icon = symbols.Variable, hl = "TSConstant" },
      Constant = { icon = symbols.Constant, hl = "TSConstant" },
      String = { icon = symbols.String, hl = "TSString" },
      Number = { icon = symbols.Number, hl = "TSNumber" },
      Boolean = { icon = symbols.Boolean, hl = "TSBoolean" },
      Array = { icon = symbols.Array, hl = "TSConstant" },
      Object = { icon = symbols.Object, hl = "TSType" },
      Key = { icon = symbols.Key, hl = "TSType" },
      Null = { icon = symbols.Null, hl = "TSType" },
      EnumMember = { icon = symbols.EnumMember, hl = "TSField" },
      Struct = { icon = symbols.Struct, hl = "TSType" },
      Event = { icon = symbols.Event, hl = "TSType" },
      Operator = { icon = symbols.Operator, hl = "TSOperator" },
      TypeParameter = { icon = symbols.TypeParameter, hl = "TSParameter" },
    },
  },
  dependencies = "folke/which-key.nvim",
}
