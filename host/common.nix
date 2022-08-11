# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }: {
  options.dot-opts = with lib; {
    user = mkOption {
      type = types.str;
      description = "The user to use for the system";

    };
    host = mkOption {
      type = types.str;
      description = "The hostname to use for the system";

    };
  };

  config = let cfg = config.dot-opts; in {

    environment =
      {
        pathsToLink = [ "/share/zsh" ];
        systemPackages = with pkgs; [
          bash
          zsh
          git
          wget
          zip
          unzip
          coreutils
          killall
          usbutils
          ripgrep
          ripgrep-all
          neovim
          ranger
          python3

        ];
      };

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
      # Time
      timesyncd = {
        enable = true;
        servers = [ "pl.pool.ntp.org" ];
      };
      # OpenSSH daemon
      openssh.enable = true;
    };

    # User accounts
    users.users.${cfg.user} = {
      isNormalUser = true;
      home = "/home/${cfg.user}";
      shell = pkgs.zsh;
      description = "Elizabeth";
      extraGroups =
        [ "wheel" "networkmanager" "docker" ];
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
