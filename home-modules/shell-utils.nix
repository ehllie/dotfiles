{ config, lib, pkgs, ... }:
let
  inherit (pkgs.stdenv) isLinux;
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
in
{

  home.packages = attrValues
    {
      inherit (pkgs)
        cabal-install
        poetry
        cargo
        rustc
        gcc
        nodejs
        jdk17
        gleam

        git
        git-crypt
        lazygit
        cloudflared
        gh

        ffmpeg
        imagemagick
        cachix
        wget
        zip
        unzip

        erdtree
        bottom
        eza
        bat

        killall
        glow
        pandoc
        jq
        ;
    } ++ [
    pkgs.nodePackages.pnpm
    (pkgs.ghc.withPackages haskellPkgs)
    (pkgs.python3.withPackages pythonPkgs)
  ] ++ optionals isLinux [
    pkgs.lldb
  ];

  programs = {
    atuin = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };

    carapace = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };

    kitty = {
      enable = true;

      font = {
        size = 13;
        name = "CaskaydiaCove Nerd Font";
      };

      extraConfig = ''
        bold_font CaskaydiaCove NF Bold
        italic_font CaskaydiaCove NF Italic
        bold_italic_font CaskaydiaCove NF Bold Italic
      '';
    };

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

    ssh.enable = true;

    direnv = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      nix-direnv.enable = true;
      stdlib = ''
        # Two things to know:
        # * `direnv_layour_dir` is called once for every {.direnvrc,.envrc} sourced
        # * The indicator for a different direnv file being sourced is a different $PWD value
        # This means we can hash $PWD to get a fully unique cache path for any given environment

        declare -A direnv_layout_dirs
        direnv_layout_dir() {
          echo "''${direnv_layout_dirs[$PWD]:=$(
            local hash="$(sha1sum - <<<"''${PWD}" | cut -c-7)"
            local path="''${PWD//[^a-zA-Z0-9]/-}"
            echo "${config.xdg.cacheHome}/direnv/layouts/''${hash}''${path}"
          )}"
        }
      '';
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
