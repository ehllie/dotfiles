{ extraLib, ... }:
let
  inherit (extraLib.nixvim) lazyMapping;
in
{

  colorscheme = "catppuccin";
  colorschemes.catppuccin = {
    enable = true;
    lazyLoad.enable = true;
    settings.flavour = "frappe";
  };

  plugins = {

    web-devicons.enable = true;
    notify.enable = true;
    scrollview.enable = true;
    gitsigns.enable = true;
    trouble = {
      enable = true;
      lazyLoad.settings = {
        cmd = "Trouble";
        keys = map lazyMapping [
          [
            "<leader>ts"
            "<cmd>Trouble symbols toggle<cr>"
            { desc = "Toggle LSP symbols with Trouble"; }
          ]
          [
            "<leader>td"
            "<cmd>Trouble diagnostics toggle<cr>"
            { desc = "Toggle LSP diagnostics with Trouble"; }
          ]
          [
            "<leader>tt"
            "<cmd>Trouble todo toggle<cr>"
            { desc = "Toggle TODOs with Trouble"; }
          ]
        ];

      };
    };
    todo-comments.enable = true;

    noice = {
      enable = true;
      settings = {
        lsp = {
          override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
          };
          hover.opts.border = "rounded";
        };
        presets = {
          bottom_search = false;
          command_palette = true;
        };
        routes = [
          {
            view = "notify";
            filter = {
              event = "msg_show";
              kind = "shell_out";
            };
          }
          {
            filter = {
              event = "notify";
              find = "No information available";
            };
            opts = {
              skip = true;
            };
          }
        ];
      };
    };
  };
}
