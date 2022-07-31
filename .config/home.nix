{ config, pkgs, lib, inputs, ... }:

{

  home = {
    username = "ellie";
    homeDirectory = "/home/ellie";

    # Add locations to PATH
    sessionPath = [ "~/.local/bin" ];

    # xdg.enable = true;

    # Add environment variables
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };


    stateVersion = "22.05";
  };

  imports = [
    ./zsh/zsh.nix
    ./home_apps.nix
    ./nvim/nvim.nix
  ];

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "ehllie";
      userEmail = "me@ehllie.xyz";
      extraConfig = {
        defaultBranch = "main";
      };
    };
  };

  xdg.configFile = {
    "mypy/config".source = ./mypy/config;
    "python/config".source = ./python/pythonrc.py;
  };
}
