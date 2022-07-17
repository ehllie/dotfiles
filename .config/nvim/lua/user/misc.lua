-- Setup for minor plugins

local colorscheme = "catppuccin"

if colorscheme == "catppuccin" then
  vim.g.catppuccin_flavour = "macchiato"
end

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  return
end

vim.g.Illuminate_ftblacklist = { "alpha", "NvimTree" }
vim.g.Illuminate_highlightUnderCursor = 0
vim.api.nvim_set_keymap("n", "<a-n>", '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>', { noremap = true })
vim.api.nvim_set_keymap(
  "n",
  "<a-p>",
  '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>',
  { noremap = true }
)

return {
  {
    deps = "colorizer",
    setup = function(colorizer)
      colorizer.setup({
        "css",
        "javascript",
        "typescript",
        "vue",
        "html",
        "lua",
      })
    end,
  },
  {
    deps = "indent_blankline",
    setup = function(indent_blankline)
      indent_blankline.setup({
        char = "▏",
        show_trailing_blankline_indent = false,
        show_first_indent_level = true,
        use_treesitter = true,
        show_current_context = true,
        buftype_exclude = { "terminal", "nofile" },
        filetype_exclude = {
          "help",
          "packer",
          "NvimTree",
        },
      })
    end,
  },
  {
    deps = "scrollbar",
    setup = function(scrollbar)
      vim.api.nvim_create_autocmd({ "WinScrolled", "VimResized", "QuitPre" }, {
        callback = function()
          scrollbar.show()
        end,
      })

      vim.api.nvim_create_autocmd({ "WinEnter", "FocusGained" }, {
        callback = function()
          scrollbar.show()
        end,
      })

      vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave", "BufWinLeave", "FocusLost" }, {
        callback = function()
          scrollbar.clear()
        end,
      })
    end,
  },
  {
    deps = "nvim-ts-autotag",
    setup = function(autotag)
      autotag.setup()
    end,
  },
  {
    deps = "nvim-autopairs",
    setup = function(npairs)
      npairs.setup({
        check_ts = true, -- treesitter integration
        disable_filetype = { "TelescopePrompt" },
      })

      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp_status_ok, cmp = pcall(require, "cmp")
      if not cmp_status_ok then
        return
      end
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({}))
    end,
  },
  {
    deps = "copilot",
    setup = function(copilot)
      vim.defer_fn(function()
        copilot.setup({
          cmp = {
            enabled = true,
            method = "getPanelCompletions",
          },
          panel = {
            enabled = true,
          },
        })
      end, 100)
    end,
  },
  {
    deps = "impatient",
    setup = function(impatient)
      impatient.enable_profile()
    end,
  },
  {
    deps = "gitsigns",
    setup = function(gitsigns)
      gitsigns.setup({
        signs = {
          add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
          change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
          delete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
          topdelete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
          changedelete = {
            hl = "GitSignsChange",
            text = "▎",
            numhl = "GitSignsChangeNr",
            linehl = "GitSignsChangeLn",
          },
        },
      })
    end,
  },
  {
    deps = "shade",
    setup = function(shade)
      shade.setup({
        overlay_opacity = 50,
        opacity_step = 1,
      })
    end,
  },
}
