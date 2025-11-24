{ extraLib, ... }:
let
  inherit (extraLib.nixvim) lazyMapping;
in
{

  plugins.telescope = {
    enable = true;
    settings.defaults = {
      path_display = [ "smart" ];
      file_ignore_patterns = [
        "^node_modules/"
        "^.git/"
        "^.mypy_cache/"
        "^__pycache__/"
        "^output/"
        "^data/"
        "%.ipynb"
      ];
      mappings = {
        i = {
          "<c-c>" = "close";
          "<c-j>" = "move_selection_next";
          "<c-k>" = "move_selection_previous";
          "<c-h>" = "which_key";
          "<down>" = "cycle_history_next";
          "<up" = "cycle_history_prev";
        };
        n.q = "close";
      };
    };
    lazyLoad.settings = {
      cmd = "Telescope";
      keys = map lazyMapping [
        [
          "<leader>fa"
          "<cmd>Telescope builtin<cr>"
          { desc = "Select a builtin picker"; }
        ]
        [
          "<leader>fb"
          "<cmd>Telescope buffers<cr>"
          { desc = "Find buffers"; }
        ]
        [
          "<leader>ff"
          "<cmd>Telescope find_files<cr>"
          { desc = "Find files"; }
        ]
        [
          "<leader>fh"
          "<cmd>Telescope help_tags<cr>"
          { desc = "Neovim documentation"; }
        ]
        [
          "<leader>fl"
          "<cmd>Telescope diagnostics<cr>"
          { desc = "LSP diagnostics"; }
        ]
        [
          "<leader>fg"
          "<cmd>Telescope live_grep<cr>"
          { desc = "Live grep"; }
        ]
        [
          "<leader>fn"
          "<cmd>Telescope notify<cr>"
          { desc = "Notification history"; }
        ]
      ];
    };
  };
}
