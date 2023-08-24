return {
  "akinsho/toggleterm.nvim",
  config = function(_, opts)
    require("toggleterm").setup(opts)

    local Terminal = require("toggleterm.terminal").Terminal
    local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })

    require("which-key").register({
      ["<leader>g"] = {
        name = "Git",
        ["g"] = {
          function()
            lazygit:toggle()
          end,
          "Open lazygit",
        },
      },
      [ [[<C-\>]] ] = "Open terminal",
    })
  end,
  opts = {
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
  },
  dependencies = "folke/which-key.nvim",
}
