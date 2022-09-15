{ config, pkgs, lib, myLib, ... }:
let
  cfg = config.dotfiles;

  appPack = with pkgs; [
    libreoffice
    dmenu
  ];
  mediaPack = with pkgs; [
    firefox
    thunderbird
    protonvpn-gui
    pavucontrol
    vlc
    discord
  ];
in
{
  imports = [ ./gnome.nix ./xmonad ./taffybar ./rofi ];

  options.dotfiles = with lib; {
    graphical = mkEnableOption "graphical";
    windowManager = mkOption {
      type = with types; nullOr (enum [ "none" ]);
      default = "none";
    };
  };

  config = lib.mkIf cfg.graphical (myLib.dualDefinitions {
    hostDefinitions = {
      services = {
        xserver = {
          layout = "pl";
          libinput = {
            enable = true;
            touchpad = {
              naturalScrolling = true;
            };
          };
          desktopManager.xterm.enable = false;
          excludePackages = [ pkgs.xterm ];
        };
        gnome.gnome-keyring.enable = true;
      };
      programs = {
        _1password-gui = { enable = true; polkitPolicyOwners = [ cfg.userName ]; };
        dconf.enable = true;
      };
    };
    userDefinitions =
      let
        protonmail-cli = pkgs.writeShellScriptBin "protonmail-cli" ''
          systemctl --user stop protonmail-bridge.service
          ${pkgs.protonmail-bridge}/bin/protonmail-bridge --cli
          systemctl --user start protonmail-bridge.service
        '';
      in
      {
        systemd.user.services.protonmail-bridge = {
          Unit = {
            Description = "Protonmail Bridge";
            After = [ "network.target" ];
          };
          Service = {
            Type = "simple";
            ExecStart = "${pkgs.protonmail-bridge}/bin/protonmail-bridge -l info --noninteractive";
            Restart = "on-failure";
            RestartSec = 3;
          };
          Install = {
            WantedBy = [ "default.target" ];
          };
        };
        home = {
          packages = appPack ++ mediaPack ++ [ protonmail-cli ];
          sessionVariables.OP_BIOMETRIC_UNLOCK_ENABLED = true;
        };
      };
  });
}
