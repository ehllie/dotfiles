{ config, pkgs, lib, myLib, ... }:
let
  cfg = config.dotfiles;

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
in
{
  imports = [ ./gnome.nix ];

  options.dotfiles.graphical = lib.mkEnableOption "graphical";


  config = lib.mkIf cfg.graphical (myLib.dualDefinitions {
    hostDefinitions = {
      programs._1password-gui = { enable = true; polkitPolicyOwners = [ cfg.userName ]; };
    };
    userDefinitions = {
      home.packages = builtins.concatLists [ appPack mediaPack ];
    };
  });
}
