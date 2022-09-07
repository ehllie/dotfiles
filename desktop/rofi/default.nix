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
in
myLib.dualDefinitions {
  inherit userDefinitions hostDefinitions;
}
