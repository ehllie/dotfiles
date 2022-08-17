{ config, pkgs, ... }:
let

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
    discord
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
  config = {
    home.packages = builtins.concatLists [ appPack mediaPack gtkPack ];
    gtk = {
      enable = true;
      theme = {
        package = pkgs.catppuccin-gtk;
        name = "Catppuccin";
      };
    };
    nixpkgs.overlays =
      let
        discordOverlay = self: super: {
          discord = super.discord.override { withOpenASAR = true; };
        };
      in
      [ discordOverlay ];
  };
}
