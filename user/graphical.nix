{ config, pkgs, lib, ... }:
let
  cfg = config.dot-opts;
  appPack = with pkgs; [
    libreoffice
    dmenu
    _1password
    _1password-gui
  ];
  mediaPack = with pkgs; [
    firefox-wayland
    thunderbird-wayland
    protonmail-bridge
    protonvpn-gui
    vlc
    (discord.override { nss = nss_latest; })
  ];
  gtkPack = with pkgs; [
    gtk-engine-murrine
    dconf
    gnome.dconf-editor
    gnome.gnome-tweaks
    gnome.gnome-themes-extra
  ];
in
{
  options.dot-opts.graphical = lib.mkEnableOption "graphical";
  config = lib.mkIf cfg.graphical {
    home.packages = builtins.concatLists [ appPack mediaPack gtkPack ];
    gtk = {
      enable = true;
      theme = {
        package = pkgs.catppuccin-gtk;
        name = "Catppuccin";
      };
    };
  };
}
