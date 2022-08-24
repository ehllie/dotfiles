{ config, pkgs, lib, inputs, ... }:
let
  cfg = config.dot-opts;
  devPack = with pkgs; [
    gcc
    cargo
    rustc
    nodePackages.pnpm
    python3
    pkgconfig
    nodejs
    go
    poetry
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
    ./zsh
    ./nvim
    ./graphical.nix
  ];

  options.dot-opts = with lib; {
    userName = mkOption {
      type = types.str;
      description = "The user to use for the system";
    };
    hostName = mkOption {
      type = types.str;
      description = "The hostname to use for the system";
    };
  };

  config = {
    home = {
      username = cfg.userName;
      homeDirectory = "/home/${cfg.userName}";
      packages = builtins.concatLists [ devPack cliPack ];
      sessionPath = [ "~/.local/bin" ];
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
      ssh = {
        enable = true;
        extraConfig = "IdentityAgent ~/.1password/agent.sock";
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
