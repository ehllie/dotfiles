{ config, dfconf, extra, lib, pkgs, ... }:
let
  hostDefinitions = {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };

  userDefinitions = {
    home.packages = with pkgs; [
      gtk-engine-murrine
      dconf
      gnome.dconf-editor
      gnome.gnome-tweaks
      gnome.gnome-themes-extra
    ];
  };
in
extra.enumDefinitions [ "windowManager" ] "gnome"
  (extra.dualDefinitions { inherit userDefinitions hostDefinitions; })
