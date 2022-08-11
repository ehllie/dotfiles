{ config, pkgs, ... }:
{
  config = {
    home.packages = with pkgs; [ gtk-engine-murrine dconf gnome.dconf-editor gnome.gnome-tweaks gnome.gnome-themes-extra ];
    gtk = {
      enable = true;
      theme = {
        package = pkgs.catppuccin-gtk;
        name = "Catppuccin";
      };
    };
  };
}
