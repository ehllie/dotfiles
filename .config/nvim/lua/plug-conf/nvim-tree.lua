local function config()
  local tree_cb = require("nvim-tree.config").nvim_tree_callback

  require("nvim-tree").setup({
    update_focused_file = {
      enable = true,
      update_cwd = true,
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
      height = 30,
      side = "left",
      mappings = {
        list = {
          { key = { "l", "<CR>", "o" }, cb = tree_cb("edit") },
          { key = "h", cb = tree_cb("close_node") },
          { key = "v", cb = tree_cb("vsplit") },
        },
      },
    },
  })

  require("which-key").register({ ["<leader>e"] = { ":NvimTreeToggle<CR>", "Toggle NvimTree" } })
end

return { "kyazdani42/nvim-tree.lua", config = config, requires = "folke/which-key.nvim" }
