{ config, lib, pkgs, modulesPath, ... }:
let cfg = config.dotfiles; in {
  imports = [
    ./dell-gram.nix
    ./desktop.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  options.dotfiles = with lib; {
    hardware = mkOption {
      description = "The machine for which to setup hardware configuration for.";
      type = with types; nullOr (enum [ "none" ]);
      default = "none";
    };
    fido = {
      enable = mkEnableOption "fido";
      credential = mkOption {
        type = types.str;
        default = "";
        description = "FIDO credential";
      };
    };
    samba = mkEnableOption "samba";
  };

  config = lib.mkIf (cfg.hardware != "none") {
    boot = {
      plymouth.enable = true;
      loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = 3;
        };
        efi.canTouchEfiVariables = true;
        timeout = 0;
      };
    };
    boot.blacklistedKernelModules = [ "pcspkr" ];

    fileSystems."/" = { device = "/dev/vg1/root"; fsType = "ext4"; };
    swapDevices = [{ device = "/dev/vg1/swap"; }];

    networking = {
      networkmanager.enable = true;
      firewall = {
        allowedTCPPorts =
          if cfg.samba then [
            5357 # wsdd
          ] else [ ];
        allowedUDPPorts =
          if cfg.samba then [
            3702 # wsdd
          ] else [ ];
      };
    };

    services = {
      blueman.enable = true;
      dbus = {
        enable = true;
        packages = with pkgs;[ dconf ];
      };
      printing = {
        enable = true;
        drivers = with pkgs;[ brlaser ];
      };
      thermald.enable = true;
      upower.enable = true;
      udisks2.enable = true;
      openssh.enable = true;

      samba-wsdd.enable = cfg.samba; # make shares visible for windows 10 clients
      samba = lib.mkIf cfg.samba {
        enable = true;
        openFirewall = true;
        extraConfig = ''
          guest account = ${cfg.userName}
          map to guest = Bad User

          follow symlinks = yes
          unix extensions = no
          wide links = yes

          load printers = no
          printcap name = /dev/null

          log file = /var/log/samba/client.%I
          log level = 2
        '';

        shares = {
          Code = {
            "path" = "/home/${cfg.userName}/Code/samba";
            "guest ok" = "no";
            "read only" = "no";
          };
        };
      };
    };

    virtualisation.docker.enable = true;
    systemd.services.upower.enable = true;
    sound.enable = true;
  };
}
