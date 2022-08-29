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
  imports = [ ./gnome.nix ./xmonad ];

  options.dotfiles = with lib; {
    graphical = mkEnableOption "graphical";
    windowManager = mkOption {
      type = with types; nullOr (enum [ "none" ]);
      default = "none";
    };
  };

  config = lib.mkIf cfg.graphical (myLib.dualDefinitions {
    hostDefinitions = {
      services.xserver = {
        layout = "pl";
        videoDrivers = [ "modesetting" ];
        libinput = {
          enable = true;
          touchpad = {
            naturalScrolling = true;
          };
        };
        desktopManager.xterm.enable = false;
        excludePackages = [ pkgs.xterm ];
      };
      # Begone xterm
      programs._1password-gui = { enable = true; polkitPolicyOwners = [ cfg.userName ]; };
    };
    userDefinitions = {
      home.packages = builtins.concatLists [ appPack mediaPack ];
    };
  });
}
