{ ezModules, lib, ... }:
{

  imports = lib.attrValues {
    inherit (ezModules)
      # alacritty
      builder-ssh
      catppuccin
      neovim
      nushell
      shell-generic
      shell-utils
      tmux
      xdg
      yazi
      zsh
      ;
  };

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;

}
