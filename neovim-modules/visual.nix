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
        ];
      };
    };
  };
}
