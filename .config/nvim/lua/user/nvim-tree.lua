local function setup(nvim_tree, tree_cfg)
  local tree_cb = tree_cfg.nvim_tree_callback

  nvim_tree.setup({
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
end

return { deps = { "nvim-tree", "nvim-tree.config" }, setup = setup }
