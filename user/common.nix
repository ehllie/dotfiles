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
    ./zsh/zsh.nix
    ./nvim/nvim.nix
  ];

  options.dot-opts = with lib; {
    user = mkOption {
      type = types.str;
      description = "The user to use for the system";

    };
    host = mkOption {
      type = types.str;
      description = "The hostname to use for the system";

    };
  };

  config = let cfg = config.dot-opts; in {
    home = {
      username = cfg.user;
      homeDirectory = "/home/${cfg.user}";
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
