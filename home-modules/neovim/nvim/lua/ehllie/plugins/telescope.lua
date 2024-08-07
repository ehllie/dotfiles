return {
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      local actions = require("telescope.actions")
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "smart" },
          file_ignore_patterns = { ".git/", "node_modules" },

          mappings = {
            i = {
              ["<C-c>"] = actions.close,
              ["<Down>"] = actions.cycle_history_next,
              ["<Up>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
            n = { q = actions.close },
          },
        },

        extensions = {
          undo = {
            side_by_side = true,
            layout_strategy = "vertical",
            layout_config = {
              preview_height = 0.8,
            },
          },
        },
      })

      telescope.load_extension("undo")
      telescope.load_extension("file_browser")
    end,
    keys = {
      { "<leader>f", group = "Telescope" },
      { "<leader>fa", "<cmd>Telescope builtin<CR>", desc = "Select a builtin picker" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find buffers" },
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Neovim documentation" },
      { "<leader>fl", "<cmd>Telescope diagnostics<CR>", desc = "LSP diagnostics" },
      { "<leader>ft", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
      { "<leader>fu", "<cmd>Telescope undo undo<CR>", desc = "Undo tree" },
      { "<leader>e", "<cmd>Telescope file_browser<CR>", desc = "File tree" },
    },
    dependencies = {
      "folke/which-key.nvim",
      "nvim-lua/plenary.nvim",
      "debugloop/telescope-undo.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
    },
  },
}
