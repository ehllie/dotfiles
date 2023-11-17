local which_key_ok, wk = pcall(require, "which-key")

if not which_key_ok then
  return
end
local register = wk.register

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

-- Normal --
register({
  ["<C-h>"] = { "<C-w>h", "Move to left window" },
  ["<C-j>"] = { "<C-w>j", "Move to bottom window" },
  ["<C-k>"] = { "<C-w>k", "Move to top window" },
  ["<C-l>"] = { "<C-w>l", "Move to right window" },

  ["<C-Up>"] = { "<cmd>resize +2<CR>", "Grow window vertical" },
  ["<C-Down>"] = { "<cmd>resize -2<CR>", "Shrink window vertical" },
  ["<C-Left>"] = { "<cmd>vertical resize -2<CR>", "Shrink window horizontal" },
  ["<C-Right>"] = { "<cmd>vertical resize +2<CR>", "Grow window horizontal" },

  ["<S-l>"] = { "<cmd>bnext<CR>", "Next buffer" },
  ["<S-h>"] = { "<cmd>bprevious<CR>", "Previous window" },
  ["<S-q>"] = { "<cmd>Bdelete!<CR>", "Close buffer" },

  ["<leader>h"] = { "<cmd>nohlsearch<CR>", "Clear search highlighting" },
  ["<leader><leader>"] = { "<cmd>w<CR>", "Quick save" },
  ["<leader><C-s>"] = { "<cmd>wa<CR>", "Quick save all" },
  ["<leader>s"] = { toggle_format, "Toggle auto formatting" },
  ["<leader>v"] = { require("ehllie.utils").to_shell, "Open current project in a virtual shell if one exists" },
  ["<leader>qq"] = { "<cmd>confirm qa<CR>", "Exit neovim" },
  ["<C-w>f"] = { close_floating, "Closes all floating windows" },
})

-- Insert --
register({
  ["jk"] = { "<ESC>", "Exit insert mode" },
  ["<C-s>"] = { "<cmd>w<CR>", "Save" },
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

-- Terminal --
register({
  ["<C-n>"] = { [[<C-\><C-n>]], "Exit terminal mode" },
}, { mode = "t" })
