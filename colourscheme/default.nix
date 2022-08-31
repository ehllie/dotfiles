{ config, lib, myLib, pkgs, ... }:
with lib;
let
  yamlFormat = pkgs.formats.yaml { };
  cfg = config.dotfiles.colourscheme.alacritty;
in
{
  imports = [ ./catppuccin ];
  # options.dotfiles.colourscheme = {
  #   alacritty = mkOption {
  #     type = yamlFormat.type;
  #     default = yamlFormat;
  #   };
  # };
}
