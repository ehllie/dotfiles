{ lib, pkgs, ... }:
let
  inherit (lib) attrValues;

  protonmail-cli = pkgs.writeShellScriptBin "protonmail-cli" ''
    systemctl --user stop protonmail-bridge.service
    ${pkgs.protonmail-bridge}/bin/protonmail-bridge --cli
    systemctl --user start protonmail-bridge.service
  '';

  packages = attrValues {
    inherit (pkgs)
      libreoffice
      dmenu
      xdotool
      firefox
      thunderbird
      protonvpn-gui
      pavucontrol
      networkmanagerapplet
      vlc
      discord
      spectacle
      prismlauncher;
    inherit protonmail-cli;
  };
in
{
  imports = [ ./taffybar ./xmonad ./rofi.nix ];
  services.gpg-agent.enable = true;

  programs.ssh.extraConfig = ''
    IdentityAgent ~/.1password/agent.sock
  '';

  systemd.user.services.protonmail-bridge = {
    Install.WantedBy = [ "default.target" ];

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
  };

  home = {
    inherit packages;
    sessionVariables.OP_BIOMETRIC_UNLOCK_ENABLED = true;
  };

}
