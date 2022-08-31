{ config, lib, myLib, ... }:
let colourscheme = config.dotfiles.colourscheme.alacritty; in
myLib.userDefinitions {
  programs = {
    alacritty.settings = {
      font = {
        normal = {
          family = "Cascadia Code";
          style = "Regular";
        };
        italic.style = "Italic";
        bold.style = "Bold";
        bold_italic.style = "Bold Italic";
        size = 12;
      };

    };
    tmux = {
      enable = true;
      terminal = "xterm-256color";
      extraConfig = ''set-option -ga terminal-overrides ",xterm-256color:Tc"'';
    };
  };
}
  
