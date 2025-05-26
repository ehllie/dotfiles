{ ezModules, lib, inputs, ... }:
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

  nixpkgs.config = import ../nixpkgs-config.nix;
  xdg.configFile."nixpkgs/config.nix".source = ../nixpkgs-config.nix;
  programs.home-manager.enable = true;
  services.ollama.enable = true;
}
