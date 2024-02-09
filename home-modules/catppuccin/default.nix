{ lib, pkgs, ... }:
let
  inherit (pkgs.stdenv) isLinux;
  inherit (lib) mkIf;
  flavour = "frappe";
  palette =
    if flavour == "latte" then import ./latte.nix
    else if flavour == "frappe" then import ./frappe.nix
    else if flavour == "macchiato" then import ./macchiato.nix
    else import ./mocha.nix;

  escapedPalette = lib.mapAttrs (_: color: lib.strings.escapeShellArg color) palette;

  toWord = str:
    let
      chars = lib.strings.stringToCharacters str;
      head = builtins.head chars;
      tail = builtins.tail chars;
    in
    lib.strings.concatStrings ([ (lib.strings.toUpper head) ] ++ tail);
in
{
  programs = {
    kitty.theme = "Catppuccin-${toWord flavour}";


    alacritty.settings.colors = {
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

    nushell.extraConfig = ''
      let theme = {
        separator: ${escapedPalette.overlay0}
        leading_trailing_space_bg: ${escapedPalette.overlay0}
        header: ${escapedPalette.green}
        date: ${escapedPalette.mauve}
        filesize: ${escapedPalette.blue}
        row_index: ${escapedPalette.pink}
        bool: ${escapedPalette.peach}
        int: ${escapedPalette.peach}
        duration: ${escapedPalette.peach}
        range: ${escapedPalette.peach}
        float: ${escapedPalette.peach}
        string: ${escapedPalette.green}
        nothing: ${escapedPalette.peach}
        binary: ${escapedPalette.peach}
        cellpath: ${escapedPalette.peach}
        hints: dark_gray

        shape_garbage: { fg: ${escapedPalette.crust} bg: ${escapedPalette.red} attr: b }
        shape_bool: ${escapedPalette.blue}
        shape_int: { fg: ${escapedPalette.mauve} attr: b}
        shape_float: { fg: ${escapedPalette.mauve} attr: b}
        shape_range: { fg: ${escapedPalette.yellow} attr: b}
        shape_internalcall: { fg: ${escapedPalette.blue} attr: b}
        shape_external: { fg: ${escapedPalette.blue} attr: b}
        shape_externalarg: ${escapedPalette.text}
        shape_literal: ${escapedPalette.blue}
        shape_operator: ${escapedPalette.yellow}
        shape_signature: { fg: ${escapedPalette.green} attr: b}
        shape_string: ${escapedPalette.green}
        shape_filepath: ${escapedPalette.yellow}
        shape_globpattern: { fg: ${escapedPalette.blue} attr: b}
        shape_variable: ${escapedPalette.text}
        shape_flag: { fg: ${escapedPalette.blue} attr: b}
        shape_custom: {attr: b}
      }

      $env.config.color_config = $theme
    '';

  };
  gtk = mkIf isLinux {
    enable = true;
    theme = {
      package = pkgs.catppuccin-gtk;
      name = "Catppuccin-Dark";
    };
  };
}
