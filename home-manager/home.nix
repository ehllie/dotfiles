{ config, pkgs, lib, inputs, ... }:

{

  home = {
    # Add locations to PATH
    sessionPath = [ "~/.local/bin" ];

    # Add environment variables
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    stateVersion = "22.05";
  };

  imports = [
    ./zsh/zsh.nix
    ./home-apps.nix
    ./nvim/nvim.nix
    ./gtk.nix
    ./test-module.nix
  ];

  test-module.enabled = true;

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "Elizabeth Paź";
      userEmail = "me@ehllie.xyz";
      extraConfig.init = {
        defaultBranch = "main";
      };
    };
  };

  xdg = {
    enable = true;
    configFile = {
      "mypy/config".source = ./mypy/config;
      "python/config".source = ./python/pythonrc.py;
    };
  };

}
