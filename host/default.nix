# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:
let cfg = config.dot-opts.host; in {

  imports = [ ./bare-metal.nix ];

  options.dot-opts.host = with lib; {
    userName = mkOption {
      type = types.str;
      description = "The user to use for the system";

    };
    hostName = mkOption {
      type = types.str;
      description = "The hostname to use for the system";

    };
  };

  config = {
    environment = {
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
        #Security

        pam_u2f
        fido2luks
      ];
    };

    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';
    nixpkgs.config.allowUnfree = true;

    fonts.fonts = with pkgs; [
      # Nerd Fonts
      cascadia-code
      nerdfonts
    ];

    # Networking
    networking = {
      hostName = cfg.hostName;
      firewall = {
        allowPing = true;
        enable = true;
      };
    };

    # Timezone
    time.timeZone = "Europe/Warsaw";

    # Locales
    i18n.defaultLocale = "en_IE.utf8";
    console.keyMap = "pl";

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
    users.users.${cfg.userName} = {
      isNormalUser = true;
      home = "/home/${cfg.userName}";
      shell = pkgs.zsh;
      description = "Elizabeth";
      extraGroups =
        [ "wheel" "networkmanager" "docker" ];
      initialPassword = "password"; # Change this asap obv
    };

    # Sudo
    security = {
      sudo = {
        enable = true;
        wheelNeedsPassword = true;
      };

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
