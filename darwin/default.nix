{ pkgs, ... }: {

  programs.zsh.enable = true;
  security.pam.enableSudoTouchIdAuth = true;
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "python3.10-poetry-1.2.2"
    ];
  };

  homebrew = {
    enable = true;
    casks = [
      "neovide"
      "1password"
      "discord"
      "microsoft-office"
      "microsoft-teams"
      "protonmail-bridge"
      "protonvpn"
      "firefox"
      "steam"
      "pritunl"
      "adobe-acrobat-pro"
      "mos"
      "xiv-on-mac"
      "aldente"
      "teamviewer"
      "calibre"
      "prismlauncher"
      "maccy"
      "transmission"
      "vlc"
      "signal"
      "keycastr"
      "keyboard-cleaner"
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
      # sandbox = true;
      trusted-substituters = [ "https://nix-community.cachix.org" ];
      extra-substituters = [ "https://nix-community.cachix.org" ];
      extra-trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
      interval = { Hour = 3; Minute = 15; Weekday = 6; };
    };
  };
  services.nix-daemon.enable = true;
  # users.users.${dfconf.userName} = {
  #   home = dfconf.homeDir;
  #   description = dfconf.userDesc;
  # };
}
