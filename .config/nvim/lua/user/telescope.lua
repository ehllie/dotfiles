local function setup(telescope, actions, project)
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

  project.setup({

    -- detection_methods = { "lsp", "pattern" }, -- NOTE: lsp detection will get annoying with multiple langs in one project
    detection_methods = { "pattern" },

    -- patterns used to detect root dir, when **"pattern"** is in detection_methods
    patterns = { ".git", "Makefile", "package.json" },
  })

  telescope.load_extension("projects")
end

return { deps = { "telescope", "telescope.actions", "project" }, setup = setup }
