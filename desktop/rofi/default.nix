{ config, lib, myLib, pkgs, ... }:
let
  hostDefinitions = { };
  userDefinitions = {
    programs.rofi = {
      extraConfig = {
        kb-row-up = "Control+k";
        kb-row-down = "Control+j";
        kb-remove-to-eol = "";
        kb-accept-entry = "Control+l,Control+m,Return,KP_Enter";
        kb-mode-complete = "";
      };
    };
  };
  enable = config.dotfiles.windowManager == "xmonad";
in
lib.mkIf enable (myLib.dualDefinitions {
  inherit userDefinitions hostDefinitions;
})
