{
  ezModules,
  lib,
  inputs,
  pkgs,
  ...
}:
{
  imports = lib.attrValues {
    inherit (ezModules)
      jellyfin
      # alacritty
      builder-ssh
      catppuccin
      neovim
      # nushell
      shell-generic
      shell-utils
      tmux
      xdg
      yazi
      opencode
      zsh
      ;
  };

  nix = {
    package = pkgs.nix;
    extraOptions = "experimental-features = nix-command flakes pipe-operators";
    registry.nixpkgs.flake = inputs.nixpkgs;
    gc = {
      automatic = true;
      dates = "monthly";
      options = "--delete-older-than 7d";
    };
    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
    ];
  };

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;
}
