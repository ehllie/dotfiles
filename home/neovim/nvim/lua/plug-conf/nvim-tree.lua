local function config()
  local register = require("which-key").register
  local api = require("nvim-tree.api")

  require("nvim-tree").setup({
    update_focused_file = {
      enable = true,
      update_cwd = true,
      ignore_list = { "toggleterm" },
    },
    renderer = {
      root_folder_modifier = ":t",
      icons = {
        glyphs = {
          default = "",
          symlink = "",
          folder = {
            arrow_open = "",
            arrow_closed = "",
            default = "",
            open = "",
            empty = "",
            empty_open = "",
            symlink = "",
            symlink_open = "",
          },
          git = {
            unstaged = "",
            staged = "S",
            unmerged = "",
            renamed = "➜",
            untracked = "U",
            deleted = "",
            ignored = "◌",
          },
        },
      },
    },
    actions = {
      open_file = {
        window_picker = {
          exclude = {
            buftype = { "nofile", "terminal", "help", "prompt" },
          },
        },
      },
    },
    diagnostics = {
      enable = true,
      show_on_dirs = true,
      icons = {
        hint = "",
        info = "",
        warning = "",
        error = "",
      },
    },
    filters = {
      custom = { "\\~formatter.*" },
    },
    view = {
      width = 30,
      side = "left",
    },
    on_attach = function(bufnr)
      register({
        l = { api.node.open.edit, "Open file" },
        h = { api.node.navigate.parent_close, "Close directory" },
        v = { api.node.open.vertical, "Open file in vertical split" },
      }, { buffer = bufnr })
    end,
  })

  register({ ["<leader>e"] = { ":NvimTreeToggle<CR>", "Toggle NvimTree" } })
end

return { "kyazdani42/nvim-tree.lua", config = config, requires = "folke/which-key.nvim" }
