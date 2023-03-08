{ config, lib, pkgs, ... }:
let
  inherit (pkgs.stdenv) isLinux isDarwin;
  inherit (lib) optionals attrValues;
  haskellPkgs = ps: attrValues
    {
      inherit (ps)
        cabal-fmt
        fourmolu
        haskell-language-server;
    } ++ optionals isLinux (attrValues
    {
      inherit (ps)
        xmonad
        xmonad-contrib
        xmonad-extras
        taffybar;
    });


  pythonPkgs = ps: attrValues {
    inherit (ps)
      black
      flake8
      isort
      mypy
      pynvim
      debugpy;
  };

  packages = attrValues
    {
      inherit (pkgs)
        cabal-install
        poetry

        cargo
        rustc
        gcc
        nodejs
        jdk

        git
        git-crypt
        lazygit

        cachix
        wget
        zip
        unzip
        docs-gen

        btop
        killall
        glow
        tree
        pandoc
        jq;
    } ++ [
    pkgs.nodePackages.pnpm
    (pkgs.ghc.withPackages haskellPkgs)
    (pkgs.python3.withPackages pythonPkgs)
  ] ++ optionals isLinux [
    pkgs.lldb
  ];
in
{

  imports = [
    ./alacritty.nix
    ./catppuccin
    ./neovim
    ./xdg.nix
    ./zsh.nix
  ];

  home = { inherit packages; };

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      extraConfig = {
        init.defaultBranch = "main";
        merge.conflictStyle = "diff3";
      };
      signing = {
        key = null;
        signByDefault = true;
      };
    };

    gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
    };

    ssh = {
      enable = true;
    };
  };

  xdg.configFile = {
    "mypy/config".text = ''
      [mypy]
      python_version = 3.10
      strict = True
      no_implicit_optional = False
    '';
    "lazygit/config.yml".text = ''
      git:
        autoFetch: false
    '';
    "cabal/config".text = ''
      repository hackage.haskell.org
        url: http://hackage.haskell.org/

      remote-repo-cache: ${config.xdg.cacheHome}/cabal/packages
      extra-prog-path: ${config.xdg.dataHome}/cabal/bin
      build-summary: ${config.xdg.dataHome}/cabal/logs/build.log
      remote-build-reporting: none
      jobs: $ncpus
      installdir: ${config.xdg.dataHome}/cabal/bin
    '';
  };
}
