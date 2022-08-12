{ config, pkgs, lib, inputs, ... }:

let
  devPack = with pkgs; [
    gcc
    cargo
    nodePackages.pnpm
    python3
    pkgconfig
    nodejs
    go
  ];
  cliPack = with pkgs; [
    zsh
    git
    wget
    zip
    lazygit
    unzip
    htop
    coreutils
    killall
    _1password
  ];
in
{
  imports = [
    ./zsh/zsh.nix
    ./nvim/nvim.nix
  ];

  config = {
    home = {
      packages = builtins.concatLists [ devPack cliPack ];
      # Add locations to PATH
      sessionPath = [ "~/.local/bin" ];

      # Add environment variables
      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };

      stateVersion = "22.05";
    };
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
  };

}