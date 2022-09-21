{ config, dfconf, extra, lib, pkgs, ... }:
let
  systemPackages = with pkgs; [
    bash
    zsh
    coreutils
    usbutils
    fido2luks
  ];

  haskellPkgs = ps: with ps; [
    xmonad
    xmonad-contrib
    xmonad-extras
    taffybar
    cabal-fmt
    fourmolu
    haskell-language-server
  ];

  pythonPkgs = ps: with ps; [
    black
    flake8
    isort
    mypy
    pynvim
    debugpy
  ];

  userPackages = with pkgs; [
    (ghc.withPackages haskellPkgs)

    (python3.withPackages pythonPkgs)
    poetry

    lldb
    cargo
    rustc
    gcc

    nodePackages.pnpm
    nodejs

    git
    git-crypt
    lazygit

    wget
    zip
    unzip

    btop
    killall
    glow
    tree
  ];

  hostDefinitions = {
    nixpkgs.config.allowUnfree = true;
    time.timeZone = "Europe/Warsaw";
    i18n.defaultLocale = "en_IE.UTF-8";
    console.keyMap = "pl";
    programs._1password.enable = true;

    environment = {
      pathsToLink = [ "/share/zsh" ];
      inherit systemPackages;
    };

    nix = {
      extraOptions = "experimental-features = nix-command flakes";

      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 7d";
      };
    };

    fonts.fonts = with pkgs; [
      cascadia-code
      (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
    ];

    networking = {
      hostName = dfconf.hostName;

      firewall = {
        allowPing = true;
        enable = true;
      };
    };

    services.timesyncd = {
      enable = true;
      servers = [ "pl.pool.ntp.org" ];
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };

    users.users.${dfconf.userName} = {
      isNormalUser = true;
      home = "/home/${dfconf.userName}";
      description = dfconf.userDesc;
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

  userDefinitions = { config, ... }: {
    services.gpg-agent.enable = true;

    home = {
      username = dfconf.userName;
      homeDirectory = "/home/${dfconf.userName}";
      packages = userPackages;
      stateVersion = "22.05";
    };

    programs = {
      home-manager.enable = true;

      git = {
        enable = true;
        userName = "Elizabeth Paź";
        userEmail = "me@ehllie.xyz";
        extraConfig.init.defaultBranch = "main";
      };

      gpg = {
        enable = true;
        homedir = "${config.xdg.dataHome}/gnupg";
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
      "lazygit/config.yml".text = ''
        git:
          autoFetch: false
      '';
    };
  };
in
{
  imports = [
    ./colourscheme
    ./desktop
    ./hardware
    ./neovim
    ./shell
    ./terminal
  ];

  config = lib.recursiveUpdate hostDefinitions (extra.userDefinitions userDefinitions);
}
