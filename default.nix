{ config, lib, myLib, pkgs, ... }:
let
  cfg = config.dotfiles;

  hostDefinitions = {
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
        ranger
        python3
        pam_u2f
        fido2luks
      ];
    };

    nix = {
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 7d";
      };
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };
    nixpkgs.config.allowUnfree = true;

    fonts.fonts = with pkgs; [
      cascadia-code
      nerdfonts
    ];

    networking = {
      hostName = cfg.hostName;
      firewall = {
        allowPing = true;
        enable = true;
      };
    };

    time.timeZone = "Europe/Warsaw";
    i18n.defaultLocale = "en_IE.utf8";
    console.keyMap = "pl";

    services = {
      gnome.gnome-keyring.enable = true;
      timesyncd = {
        enable = true;
        servers = [ "pl.pool.ntp.org" ];
      };
      openssh.enable = true;
    };

    users.users.${cfg.userName} = {
      isNormalUser = true;
      home = "/home/${cfg.userName}";
      description = cfg.userDesc;
      extraGroups = [ "wheel" "networkmanager" "docker" ];
      initialPassword = "password"; # Change this asap obv
    };

    security.sudo = {
      enable = true;
      wheelNeedsPassword = true;
    };

    system = {
      stateVersion = "22.05";
      autoUpgrade.enable = true;
      autoUpgrade.allowReboot = true;
      autoUpgrade.channel = https://nixos.org/channels/nixos-unstable;
    };
  };

  devPack = with pkgs; [
    gcc
    cargo
    rustc
    nodePackages.pnpm
    python3
    pkgconfig
    nodejs
    go
    poetry
  ];
  cliPack = with pkgs; [
    git
    wget
    zip
    lazygit
    unzip
    btop
    coreutils
    killall
    _1password
  ];

  userDefinitions = {
    home = {
      username = cfg.userName;
      homeDirectory = "/home/${cfg.userName}";
      packages = builtins.concatLists [ devPack cliPack ];
      stateVersion = "22.05";
    };
    programs = {
      home-manager.enable = true;
      git = {
        enable = true;
        userName = "Elizabeth Paź";
        userEmail = "me@ehllie.xyz";
        extraConfig.init = {
          defaultBranch = "main";
        };
      };
      ssh = {
        enable = true;
        extraConfig = "IdentityAgent ~/.1password/agent.sock";
      };
    };
    xdg.configFile = {
      "mypy/config".text = ''
        [mypy]
        python_version = 3.10
        strict = True
        no_implicit_optional = False
      '';
    };
  };
in
{
  imports = [
    ./hardware
    ./shell
    ./nvim
    ./graphical
  ];

  options.dotfiles = with lib; {
    userName = mkOption {
      type = types.str;
      description = "The user to use for the system";
    };
    userDesc = mkOption {
      type = types.str;
      description = "The user's description";
    };
    hostName = mkOption {
      type = types.str;
      description = "The hostname to use for the system";
    };
  };

  config = myLib.dualDefinitions { inherit hostDefinitions userDefinitions; };
}
