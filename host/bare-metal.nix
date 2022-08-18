{ config, lib, pkgs, ... }: {
  options.dot-opts = with lib; {
    boot-loader = mkOption {
      type = types.enum [ "grub" "systemd-boot" ];
      default = "systemd-boot";
      description = "The boot loader to use.";
    };
  };
  config = let cfg = config.dot-opts; in {
    # Bootloader.
    boot.loader = {
      systemd-boot = lib.mkIf (cfg.boot-loader == "systemd-boot") {
        enable = true;
        configurationLimit = 3;
      };
      grub = lib.mkIf (cfg.boot-loader == "grub") {
        enable = true;
      };
      efi = {
        canTouchEfiVariables = true;
      };
      timeout = 0;
    };
    # Silence bios buzzer
    boot.blacklistedKernelModules = [ "pcspkr" ];

    networking = {
      networkmanager = {
        enable = true;
      };
      firewall = {
        allowedTCPPorts = [
          5357 # wsdd
        ];
        allowedUDPPorts = [
          3702 # wsdd
        ];
      };
    };

    programs = {
      _1password-gui = {
        enable = true;
        polkitPolicyOwners = [ cfg.user ];
      };

    };
    services = {
      upower.enable = true;

      dbus = {
        enable = true;
        packages = [ pkgs.dconf ];
      };
      # CUPS
      printing.enable = true;

      blueman.enable = true;

      thermald.enable = true;

      # Samba
      samba-wsdd.enable = true; # make shares visible for windows 10 clients
      samba = {
        enable = true;
        openFirewall = true;
        extraConfig = ''
          guest account = ${cfg.user}
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
            "path" = "/home/${cfg.user}/Code/samba";
            "guest ok" = "no";
            "read only" = "no";
          };
        };
      };

      # X config
      xserver = {
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

    # Virtualization/other OS's support
    virtualisation.docker = {
      enable = true;
    };

    systemd.services.upower.enable = true;

    # Sound
    sound.enable = true;

  };
}
