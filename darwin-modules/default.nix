{ pkgs, inputs, ... }: {

  imports = [
    ../overlays
  ];

  programs.zsh.enable = true;
  security.pam.enableSudoTouchIdAuth = true;
  nixpkgs.config = {
    allowUnfree = true;
  };

  homebrew = {
    enable = true;
    casks = [
      "1password"
      "adobe-acrobat-pro"
      "aldente"
      "anydesk"
      "calibre"
      "discord"
      "docker"
      "google-chrome"
      "keycastr"
      "linearmouse"
      "maccy"
      "microsoft-office"
      "microsoft-teams"
      "nvidia-geforce-now"
      "obsidian"
      "parallels"
      "prismlauncher"
      "protonmail-bridge"
      "protonvpn"
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
    fontDir.enable = true;
    fonts = with pkgs; [
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
  };
  services.nix-daemon.enable = true;
}
