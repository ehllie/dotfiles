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
        securityType = "user";
        openFirewall = true;
        extraConfig = ''
          workgroup = WORKGROUP
          server string = smbnix
          netbios name = smbnix
          security = user
          #use sendfile = yes
          #max protocol = smb2
          # note: localhost is the ipv6 localhost ::1
          hosts allow = 192.168.0.0/16 127.0.0.1 localhost
          hosts deny = 0.0.0.0/0
          guest account = nobody
          map to guest = bad user
        '';
        shares = {
          public = {
            comment = "Public nixos share";
            path = "/home/${cfg.user}/Shares/Public";
            browseable = "yes";
            "valid users" = "NOTUSED";
            public = "yes";
            writable = "yes";
            printable = "no";
            "read only" = "no";
            "guest ok" = "yes";
            "create mask" = "0644";
            "directory mask" = "0755";
            "force user" = "ALLOWEDUSER";
            "force group" = "ALLOWEDGROUP";
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
