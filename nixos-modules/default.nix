{ pkgs, lib, inputs, ... }: {
  i18n = {
    defaultLocale = "en_IE.UTF-8";
    extraLocales = [
      "en_GB.UTF-8/UTF-8"
      "en_CA.UTF-8/UTF-8"
      "pl_PL.UTF-8/UTF-8"
    ];
  };

  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    registry.nixpkgs.flake = inputs.nixpkgs;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
    ];
  };

  environment.systemPackages = lib.attrValues {
    inherit (pkgs)
      git
      neovim
      tmux
      wget
      ;
  };

  nixpkgs.config.allowUnfree = true;

  services = {
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };
  };

}
