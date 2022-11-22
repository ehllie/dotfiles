{ utils, dfconf }:
let cond = utils.enumDefinitions' [ "windowManager" ] null; in
utils.mkDefs {
  imports = [
    ./gnome.nix
    ./xmonad
    ./taffybar
    ./rofi
  ];

  nixosDefs = { pkgs, ... }: cond {
    services = {
      gnome.gnome-keyring.enable = true;

      xserver = {
        desktopManager.xterm.enable = false;
        excludePackages = [ pkgs.xterm ];
        layout = "pl";

        libinput = {
          enable = true;
          touchpad. naturalScrolling = true;
        };
      };
    };

    programs = {
      dconf.enable = true;

      _1password-gui = {
        enable = true;
        polkitPolicyOwners = [ dfconf.userName ];
      };
    };
  };

  homeDefs = { pkgs, ... }:
    let
      protonmail-cli = pkgs.writeShellScriptBin "protonmail-cli" ''
        systemctl --user stop protonmail-bridge.service
        ${pkgs.protonmail-bridge}/bin/protonmail-bridge --cli
        systemctl --user start protonmail-bridge.service
      '';

      userPackages = with pkgs; [
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
        protonmail-cli
        spectacle
        prismlauncher
      ];
    in
    cond {
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
        packages = userPackages;
        sessionVariables.OP_BIOMETRIC_UNLOCK_ENABLED = true;
      };
    };
}
