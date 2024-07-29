{ pkgs, inputs, ezModules, ... }: {

  imports = [
    ../overlays
    ezModules.pam-reattach
  ];

  programs.zsh.enable = true;
  security.pam = {
    enablePamReattach = true;
    enableSudoTouchIdAuth = true;
  };
  nixpkgs.config = import ../nixpkgs-config.nix;

  homebrew = {
    enable = true;
    casks = [
      "1password"
      "adobe-acrobat-pro"
      "aldente"
      "anydesk"
      "arc"
      "calibre"
      "chatterino"
      "bruno"
      "discord"
      "docker"
      "keycastr"
      "linearmouse"
      "logitech-g-hub"
      "maccy"
      "microsoft-office"
      "microsoft-teams"
      "noTunes"
      "nvidia-geforce-now"
      "obsidian"
      "parallels"
      "prismlauncher"
      "protonmail-bridge"
      "protonvpn"
      "rwts-pdfwriter"
      "signal"
      "slack"
      "soundsource"
      "spotify"
      "steam"
      "teamviewer"
      "transmission"
      "via"
      "vlc"
      "xiv-on-mac"
      "yacreader"
    ];
    onActivation.cleanup = "zap";
  };

  fonts = {
    packages = with pkgs; [
      cascadia-code
      (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
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
  services.nix-daemon.enable = true;
}
