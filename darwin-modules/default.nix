{ pkgs, inputs, ezModules, ... }: {

  imports = [
    ../overlays
  ];

  programs.zsh.enable = true;
  security.pam.services.sudo_local = {
    reattach = true;
    touchIdAuth = true;
  };
  nixpkgs.config = import ../nixpkgs-config.nix;

  homebrew = {
    enable = true;
    casks = [
      "1password"
      "1password-cli"
      "adobe-acrobat-pro"
      "aldente"
      "anki"
      "anydesk"
      "arc"
      "betterdisplay"
      "blackhole-2ch"
      "bruno"
      "calibre"
      "chatterino"
      "dbeaver-community"
      "discord"
      "docker"
      "gimp"
      "istat-menus"
      "jordanbaird-ice"
      "keycastr"
      "kitty"
      "linearmouse"
      "logitech-g-hub"
      # "maccy"
      "microsoft-office"
      "microsoft-teams"
      "noTunes"
      "nvidia-geforce-now"
      "obsidian"
      "parallels"
      "postgres-unofficial"
      "prismlauncher"
      "proton-mail-bridge"
      "protonvpn"
      "qbittorrent"
      "raycast"
      "rwts-pdfwriter"
      "shadow"
      "signal"
      "slack"
      "spotify"
      "steam"
      "teamviewer"
      "via"
      "vlc"
      "xiv-on-mac"
      "yacreader"
      "zen-browser"
    ];
    onActivation.cleanup = "zap";
  };

  fonts = {
    packages = [
      pkgs.cascadia-code
      pkgs.nerd-fonts.caskaydia-cove
    ];
  };

  environment = {
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [ zsh coreutils home-manager ];
  };
  nix = {
    extraOptions = "experimental-features = nix-command flakes";

    settings = {
      trusted-users = [ "@admin" ];
      trusted-substituters = [ "https://nix-community.cachix.org" ];
      extra-substituters = [ "https://nix-community.cachix.org" ];
      extra-trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
      interval = { Hour = 3; Minute = 15; Weekday = 6; };
    };

    registry = {
      nixpkgs.flake = inputs.nixpkgs-darwin;
    };

    nixPath = [
      "nixpkgs=${inputs.nixpkgs-darwin}"
    ];
  };
}
