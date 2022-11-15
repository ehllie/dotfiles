local catppuccin = {
  "catppuccin/nvim",
  as = "catppuccin",
  run = ":CatppuccinCompile",
  config = function()
    vim.g.catppuccin_flavour = "frappe"

    require("catppuccin").setup({
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      },
      transparent_background = false,
      term_colors = false,
      compile = {
        enabled = false,
        path = vim.fn.stdpath("cache") .. "/catppuccin",
      },
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = { "italic" },
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      integrations = {
        treesitter = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
        },
        coc_nvim = false,
        lsp_trouble = false,
        cmp = true,
        lsp_saga = false,
        gitgutter = false,
        gitsigns = true,
        leap = false,
        telescope = true,
        nvimtree = {
          enabled = true,
          show_root = true,
          transparent_panel = false,
        },
        neotree = {
          enabled = false,
          show_root = true,
          transparent_panel = false,
        },
        dap = {
          enabled = true,
          enable_ui = true,
        },
        which_key = true,
        indent_blankline = {
          enabled = true,
          colored_indent_levels = false,
        },
        dashboard = false,
        neogit = false,
        vim_sneak = false,
        fern = false,
        barbar = false,
        bufferline = true,
        markdown = false,
        lightspeed = false,
        ts_rainbow = true,
        hop = true,
        notify = false,
        telekasten = false,
        symbols_outline = true,
        mini = false,
        aerial = false,
        vimwiki = false,
        beacon = false,
      },
    })
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        local colors = require("catppuccin.palettes").get_palette()
        vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = colors.lavender })
      end,
    })
    vim.cmd("colorscheme catppuccin")
  end,
}

return catppuccin
