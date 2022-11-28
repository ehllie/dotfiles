{ utils, dfconf }:
utils.mkDefs {
  homeDefs = {
    home.shellAliases.ssh = "TERM=xterm-256color; ssh";

    programs = {
      alacritty = {
        enable = true;

        settings = {
          window.dimensions = {
            columns = 130;
            lines = 36;
          };

          font = {
            italic.style = "Italic";
            bold.style = "Bold";
            bold_italic.style = "Bold Italic";
            size = dfconf.fontsize + 2;

            normal = {
              family = "CaskaydiaCove Nerd Font";
              style = "Regular";
            };
          };
        };
      };

      tmux = {
        enable = true;
        terminal = "xterm-256color";
        extraConfig = ''set-option -ga terminal-overrides ",xterm-256color:Tc"'';
      };
    };
  };
}
