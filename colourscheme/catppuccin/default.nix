{ config, dfconf, extra, lib, pkgs, ... }:
let
  flavour = lib.attrByPath
    [ "colourscheme" "catppuccin" "flavour" ]
    "frappe"
    dfconf;
  palette =
    if flavour == "latte" then import ./latte.nix
    else if flavour == "frappe" then import ./frappe.nix
    else if flavour == "macchiato" then import ./macchiato.nix
    else import ./mocha.nix;
in
extra.boolDefinitions [ "colourscheme" "catppuccin" "enable" ] (extra.userDefinitions {
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
      name = "Catppuccin-Dark";
    };
  };
})
