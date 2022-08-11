# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{

  options.dotfile-presets = with lib; {
    user = mkOption {
      type = types.str;
      description = "The user to use for the system";

    };
    hostname = mkOption {
      type = types.str;
      description = "The hostname to use for the system";

    };
    boot-loader = mkOption {
      type = types.enum [ "grub" "systemd-boot" ];
      default = "systemd-boot";
      description = "The boot loader to use.";
    };
  };

  config = let cfg = config.dotfile-presets; in {
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
        efiSysMountPoint = "/boot/efi";
      };
      timeout = 0;
    };

    # Silence bios buzzer
    boot.blacklistedKernelModules = [ "pcspkr" ];

    environment.pathsToLink = [ "/share/zsh" ];

    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';
    nixpkgs.config.allowUnfree = true;

    fonts.fonts = with pkgs;
      [
        # Nerd Fonts
        cascadia-code
        nerdfonts
      ];

    # Networking
    networking = {
      hostName = cfg.host;
      networkmanager = {
        enable = true;
      };
      firewall = {
        allowPing = true;
        enable = true;
        allowedTCPPorts = [
          5357 # wsdd
        ];
        allowedUDPPorts = [
          3702 # wsdd
        ];
      };
    };

    # Timezone
    time.timeZone = "Europe/Warsaw";

    # Locales
    i18n.defaultLocale = "en_IE.utf8";
    console = {
      # font = "Lat2-Terminus16";
      keyMap = "pl";
    };

    # Services
    services = {
      gnome.gnome-keyring.enable = true;
      upower.enable = true;

      dbus = {
        enable = true;
        packages = [ pkgs.dconf ];
      };

      # Time
      timesyncd = {
        enable = true;
        servers = [ "pl.pool.ntp.org" ];
      };

      # CUPS
      printing.enable = true;

      blueman.enable = true;

      thermald.enable = true;

      # OpenSSH daemon
      openssh.enable = true;

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
            path = "/home/ellie/Shares/Public";
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

    systemd.services.upower.enable = true;

    # Sound
    sound.enable = true;

    # User accounts
    users.users = {
      ellie = {
        isNormalUser = true;
        home = "/home/${cfg.user}";
        shell = pkgs.zsh;
        description = "Elizabeth";
        extraGroups =
          [ "wheel" "networkmanager" "docker" ];
      };
    };


    # Sudo
    security = {
      sudo = {
        enable = true;
        wheelNeedsPassword = true;
      };

    };

    # Virtualization/other OS's support
    virtualisation.docker = {
      enable = true;
    };

    # Swap
    swapDevices = [
      { device = "/dev/disk/by-label/swap"; }
    ];

    # Other
    programs = {
      zsh.enable = true;
      # slock.enable = true;
    };

    system = {
      stateVersion = "22.05";
      autoUpgrade.enable = true;
      autoUpgrade.allowReboot = true;
      autoUpgrade.channel = https://nixos.org/channels/nixos-unstable;
    };
  };

}
