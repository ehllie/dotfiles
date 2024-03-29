-- Neovide configuration

-- Resize font in gui --

vim.g.gui_font_default_size = tonumber("@fontsize@")
vim.g.gui_font_size = vim.g.gui_font_default_size
vim.g.gui_font_face = "Cascadia Code"

local function refresh_gui_font()
  vim.opt.guifont = string.format("%s:h%s", vim.g.gui_font_face, vim.g.gui_font_size)
end

local function resize_gui_font(delta)
  vim.g.gui_font_size = vim.g.gui_font_size + delta
  refresh_gui_font()
end

local function reset_gui_font()
  vim.g.gui_font_size = vim.g.gui_font_default_size
  refresh_gui_font()
end

reset_gui_font()

-- Config --
vim.g.neovide_scroll_animation_length = 0.3
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0
vim.g.neovide_input_use_logo = false
-- vim.g.neovide_fullscreen = true

-- Keymaps --

local register = require("which-key").register

register({
  ["<C-+>"] = {
    function()
      resize_gui_font(1)
    end,
    "Increase gui font size",
  },
  ["<C-->"] = {
    function()
      resize_gui_font(-1)
    end,
    "Decrease gui font size",
  },
  ["<C-0>"] = {
    reset_gui_font,
    "Reset gui font size",
  },
}, { mode = "i" })

register({
  ["<C-+>"] = {
    function()
      resize_gui_font(1)
    end,
    "Increase gui font size",
  },
  ["<C-->"] = {
    function()
      resize_gui_font(-1)
    end,
    "Decrease gui font size",
  },
  ["<C-0>"] = {
    reset_gui_font,
    "Reset gui font size",
  },
}, { mode = "n" })
