{ lib, myLib, config, pkgs, ... }:
with lib;
let cfg = config.dotfiles.colourscheme.catppuccin; in {
  options.dotfiles.colourscheme.catppuccin = {
    enable = mkEnableOption "catppuccin";
    flavour = mkOption {
      type = types.enum [
        "latte"
        "frappe"
        "macchiato"
        "mocha"
      ];
      default = "frappe";
      description = "The catppuccin colour scheme to use.";
    };
  };

  config =
    let
      palette =
        if cfg.flavour == "latte" then import ./latte.nix
        else if cfg.flavour == "frappe" then import ./frappe.nix
        else if cfg.flavour == "macchiato" then import ./macchiato.nix
        else import ./mocha.nix;
    in
    mkIf cfg.enable (myLib.userDefinitions {
      programs.alacritty.settings.colors = {
        primary = {
          background = palette.base;
          foreground = palette.text;
          dim_foreground = palette.text;
          bright_foreground = palette.text;
        };

        cursor = {
          text = palette.base;
          cursor = palette.rosewater;
        };
        vi_mode_cursor = {
          text = palette.base;
          cursor = palette.lavender;
        };

        search = {
          matches = {
            foreground = palette.base;
            background = palette.subtext0;
          };
          focused_match = {
            foreground = palette.base;
            background = palette.green;
          };
          footer_bar = {
            foreground = palette.base;
            background = palette.subtext0;
          };
        };

        hints = {
          start = {
            foreground = palette.base;
            background = palette.yellow;
          };
          end = {
            foreground = palette.base;
            background = palette.subtext0;
          };
        };

        selection = {
          text = palette.base;
          background = palette.rosewater;
        };

        normal = {
          black = palette.surface1;
          red = palette.red;
          green = palette.green;
          yellow = palette.yellow;
          blue = palette.blue;
          magenta = palette.pink;
          cyan = palette.teal;
          white = palette.subtext1;
        };

        bright = {
          black = palette.surface2;
          red = palette.red;
          green = palette.green;
          yellow = palette.yellow;
          blue = palette.blue;
          magenta = palette.pink;
          cyan = palette.teal;
          white = palette.subtext0;
        };

        dim = {
          black = palette.surface1;
          red = palette.red;
          green = palette.green;
          yellow = palette.yellow;
          blue = palette.blue;
          magenta = palette.pink;
          cyan = palette.teal;
          white = palette.subtext1;
        };

        indexed_colors = [
          { index = 16; color = palette.peach; }
          { index = 17; color = palette.rosewater; }
        ];
      };
      gtk = {
        enable = true;
        theme = {
          package = pkgs.catppuccin-gtk;
          name = "Catppuccin";
        };
      };

    });
}
