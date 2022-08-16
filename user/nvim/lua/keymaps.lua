local packer_ok, packer = pcall(require, "packer")
local which_key_ok, wk = pcall(require, "which-key")

--Remap space as leader key
vim.keymap.set("", "<Space>", "<Nop>")
vim.g.mapleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

if not which_key_ok then
  if packer_ok then
    vim.keymap.set("n", "<leader>p", packer.sync)
  end
  return
end
local register = wk.register

local function toggle_format()
  _G.do_auto_format = not do_auto_format
  if do_auto_format then
    print("Auto-formatting enabled")
  else
    print("Auto-formatting disabled")
  end
end

vim.api.nvim_create_user_command("MultiMacro", function(arg_tab)
  local reg_name = vim.fn.getcharstr()
  vim.cmd(arg_tab.line1 .. "," .. arg_tab.line2 .. "g/^/norm @" .. reg_name)
  vim.cmd("nohlsearch")
end, { nargs = 0, range = true })

-- Normal --
register({
  ["<C-h>"] = { "<C-w>h", "Move to left window" },
  ["<C-j>"] = { "<C-w>j", "Move to bottom window" },
  ["<C-k>"] = { "<C-w>k", "Move to top window" },
  ["<C-l>"] = { "<C-w>l", "Move to right window" },

  ["<C-Up>"] = { ":resize +2<CR>", "Grow window vertical" },
  ["<C-Down>"] = { ":resize -2<CR>", "Shrink window vertical" },
  ["<C-Left>"] = { ":vertical resize -2<CR>", "Shrink window horizontal" },
  ["<C-Right>"] = { ":vertical resize +2<CR>", "Grow window horizontal" },

  ["<S-l>"] = { ":bnext<CR>", "Next buffer" },
  ["<S-h>"] = { ":bprevious<CR>", "Previous window" },
  ["<S-q>"] = { "<cmd>Bdelete!<CR>", "Close buffer" },

  ["<leader>h"] = { "<cmd>nohlsearch<CR>", "Clear search highlighting" },
  ["<leader><leader>"] = { "<cmd>:w<CR>", "Quick save" },
  ["<leader>s"] = { toggle_format, "Toggle auto formatting" },
  ["<leader>v"] = { require("local-lib").to_shell, "Open current project in a virtual shell if one exists" },
  -- ["<leader>p"] = { packer.sync, "Reload packer" },
})

-- Insert --
register({
  ["jk"] = { "<ESC>", "Exit insert mode" },
  ["<C-s>"] = { "<cmd>:w<CR>", "Save" },
}, { mode = "i" })

-- Visual --
register({
  p = { [["_dP]], "Paste" }, -- Doesn't overwrite the clipboard with the replaced text
  ["<"] = { "<gv", "Reduce indent" },
  [">"] = { ">gv", "Increase indent" },
  ["@"] = { ":MultiMacro<CR>", "Run macro on selected lines" },
}, { mode = "v" })

-- Command --
register({}, { mode = "c" })
