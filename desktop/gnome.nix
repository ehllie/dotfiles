{ config, lib, myLib, pkgs, ... }:
let
  cfg = config.dotfiles;

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
    gtk = {
      enable = true;
      theme = {
        package = pkgs.catppuccin-gtk;
        name = "Catppuccin";
      };
    };
  };
in
{
  options.dotfiles.windowManager = myLib.mkEnumOption "gnome";

  config = lib.mkIf (cfg.windowManager == "gnome")
    (myLib.dualDefinitions { inherit userDefinitions hostDefinitions; });
}
