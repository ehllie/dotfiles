---comment Reusable short keymap function to reduce code repetition
---@param mode string
---@param lhs string
---@param rhs string | function
---@param opts? table
---@return nil
local function keymap(mode, lhs, rhs, opts)
  if not opts then
    opts = { silent = true }
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

--Remap space as leader key
keymap("", "<Space>", "<Nop>")
vim.g.mapleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>")
keymap("n", "<C-Down>", ":resize +2<CR>")
keymap("n", "<C-Left>", ":vertical resize -2<CR>")
keymap("n", "<C-Right>", ":vertical resize +2<CR>")

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>")
keymap("n", "<S-h>", ":bprevious<CR>")

-- Clear highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>")

-- Save buffer
keymap("n", "<leader>s", function()
  vim.g.do_auto_format = not vim.g.do_auto_format
  if vim.g.do_auto_format then
    print("Auto-formatting enabled")
  else
    print("Auto-formatting disabled")
  end
end, {silent = false})
keymap("n", "<leader><leader>", "<cmd>:w<CR>")

-- Close buffers
keymap("n", "<S-q>", "<cmd>Bdelete!<CR>")

-- Better paste
keymap("v", "p", '"_dP')

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>")

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Plugins --

-- SudaVim --
keymap("c", "w!!", "SudaWrite")

-- NvimTree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>")

-- Telescope
keymap("n", "<leader>ff", ":Telescope find_files<CR>")
keymap("n", "<leader>ft", ":Telescope live_grep<CR>")
keymap("n", "<leader>fp", ":Telescope projects<CR>")
keymap("n", "<leader>fb", ":Telescope buffers<CR>")

local M = {}
M.set = keymap

return M
