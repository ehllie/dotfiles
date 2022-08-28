{ config, lib, myLib, pkgs, ... }:
let
  cfg = config.dotfiles;

  hostDefinitions = {
    services.xserver = {
      enable = true;
      layout = "pl";
      libinput = {
        enable = true;
        touchpad = {
          naturalScrolling = true;
        };
      };
      videoDrivers = [ "modesetting" ];

      displayManager.gdm.enable = true;
      desktopManager = {
        gnome.enable = true;
      };
      # Begone xterm
      desktopManager.xterm.enable = false;
      excludePackages = [ pkgs.xterm ];
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
lib.mkIf cfg.graphical
  (myLib.dualDefinitions { inherit userDefinitions hostDefinitions; })
