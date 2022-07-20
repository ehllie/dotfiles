local function config_project()
  require("project_nvim").setup({

    -- detection_methods = { "lsp", "pattern" }, -- NOTE: lsp detection will get annoying with multiple langs in one project
    detection_methods = { "pattern" },

    -- patterns used to detect root dir, when **"pattern"** is in detection_methods
    patterns = { ".git", "Makefile", "package.json" },
  })
  require("telescope").load_extension("projects")
end

local function config_telescope()
  local telescope = require("telescope")
  local actions = require("telescope.actions")
  telescope.setup({
    defaults = {

      prompt_prefix = " ",
      selection_caret = " ",
      path_display = { "smart" },
      file_ignore_patterns = { ".git/", "node_modules" },

      mappings = {
        i = {
          ["<Down>"] = actions.cycle_history_next,
          ["<Up>"] = actions.cycle_history_prev,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
        },
      },
    },
  })
  local register = require("which-key").register
  register({
    f = {
      name = "Telescope",
      f = { ":Telescope find_files<CR>", "Find files" },
      t = { ":Telescope live_grep<CR>", "Live grep" },
      p = { ":Telescope projects<CR>", "Find projects" },
      b = { ":Telescope buffers<CR>", "Find buffers" },
    },
  }, { prefix = "<leader>" })
end

return {
  { "nvim-telescope/telescope.nvim", config = config_telescope, requires = "folke/which-key.nvim" },
  {
    "ahmedkhalf/project.nvim",
    config = config_project,
    after = "telescope.nvim",
  },
}
