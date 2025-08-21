{ ezModules, lib, inputs, pkgs, ... }:
{
  imports = lib.attrValues
    {
      inherit (ezModules)
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
        zsh
        ;
    };

  nix = {
    package = pkgs.nix;
    extraOptions = "experimental-features = nix-command flakes";
    registry.nixpkgs.flake = inputs.nixpkgs;
    gc = {
      automatic = true;
      frequency = "monthly";
      options = "--delete-older-than 7d";
    };
    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
    ];
  };

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;
}
