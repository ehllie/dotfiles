local which_key_ok, wk = pcall(require, "which-key")

if not which_key_ok then
  return
end

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

local function toggle_format()
  _G.do_auto_format = not do_auto_format
  if do_auto_format then
    print("Auto-formatting enabled")
  else
    print("Auto-formatting disabled")
  end
end

local function close_floating()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then
      vim.api.nvim_win_close(win, false)
    end
  end
end

vim.api.nvim_create_user_command("MultiMacro", function(arg_tab)
  local reg_name = vim.fn.getcharstr()
  pcall(vim.cmd, arg_tab.line1 .. "," .. arg_tab.line2 .. "g/^/norm! @" .. reg_name)
  vim.cmd("nohlsearch")
end, { nargs = 0, range = true })

wk.add({
  { -- Normal mode mappings
    { "<C-Down>", "<cmd>resize -2<CR>", desc = "Shrink window vertical" },
    { "<C-Left>", "<cmd>vertical resize -2<CR>", desc = "Shrink window horizontal" },
    { "<C-Right>", "<cmd>vertical resize +2<CR>", desc = "Grow window horizontal" },
    { "<C-Up>", "<cmd>resize +2<CR>", desc = "Grow window vertical" },
    { "<C-h>", "<C-w>h", desc = "Move to left window" },
    { "<C-j>", "<C-w>j", desc = "Move to bottom window" },
    { "<C-k>", "<C-w>k", desc = "Move to top window" },
    { "<C-l>", "<C-w>l", desc = "Move to right window" },
    { "<C-w>f", close_floating, desc = "Closes all floating windows" },
    { "<S-h>", "<cmd>bprevious<CR>", desc = "Previous window" },
    { "<S-l>", "<cmd>bnext<CR>", desc = "Next buffer" },
    { "<S-q>", "<cmd>Bdelete!<CR>", desc = "Close buffer" },
    { "<leader><C-s>", "<cmd>wa<CR>", desc = "Quick save all" },
    { "<leader><leader>", "<cmd>w<CR>", desc = "Quick save" },
    { "<leader>h", "<cmd>nohlsearch<CR>", desc = "Clear search highlighting" },
    { "<leader>qq", "<cmd>confirm qa<CR>", desc = "Exit neovim" },
    { "<leader>s", toggle_format, desc = "Toggle auto formatting" },
  },

  { -- Insert mode mappings
    mode = "i",
    { "<C-s>", "<cmd>w<CR>", desc = "Save" },
    { "jk", "<ESC>", desc = "Exit insert mode" },
  },

  { -- Visual mode mappings
    mode = "v",
    { "<", "<gv", desc = "Reduce indent" },
    { ">", ">gv", desc = "Increase indent" },
    { "@", ":MultiMacro<CR>", desc = "Run macro on selected lines" },
  },

  { -- Command mode mappings
    mode = "c",
  },

  { -- Terminal mode mappings
    mode = "t",
    { "<C-n>", "<C-\\><C-n>", desc = "Exit terminal mode" },
  },
})
