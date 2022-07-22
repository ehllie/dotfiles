local function config()
  local register = require("which-key").register
  require("toggleterm").setup({
    size = 20,
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = "float",
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = "curved",
    },
  })

  local Terminal = require("toggleterm.terminal").Terminal
  local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })
  local lgconf = Terminal:new({
    cmd = "lazygit --git-dir=${XDG_CONFIG_HOME:-$HOME/.config}/dotfile-gitdir --work-tree=$HOME",
    hidden = true,
  })

  register({
    ["<leader>gg"] = {
      function()
        lazygit:toggle()
      end,
      "Open lazygit",
    },
    ["<leader>gc"] = {
      function()
        lgconf:toggle()
      end,
      "Manage dotfile repo",
    },
    [ [[<C-\>]] ] = "Open terminal",
  })
end

return {
  "akinsho/toggleterm.nvim",
  config = config,
  requires = "folke/which-key.nvim",
}
