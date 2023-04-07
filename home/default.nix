# For general explaination of modules see the comments in darwin/default.nix
# This uses options defined in https://rycee.gitlab.io/home-manager/options.html
{ config, lib, pkgs, ... }:
let
  inherit (lib) attrValues;
  inherit (pkgs.stdenv) isDarwin;
in
{

  # You split up your configuration by using the `imports` option.
  # Nix will merge the configuration from all the modules you use together.
  imports = [ ./shell.nix ];

  home = {
    # State version needs to be set, but you don't ever need to change it
    stateVersion = "22.11";
    username = "your-username";
    # You can define custom logic in your configuration.
    homeDirectory = if isDarwin then "/Users/your-username" else "/home/your-username";

    # This is the list of user packages to install.
    # Feel free to remove any you don't need or add any you do.
    packages = attrValues {
      inherit (pkgs)
        cargo
        rustc
        gcc
        nodejs

        git-crypt
        lazygit

        ffmpeg
        imagemagick
        wget
        zip
        unzip

        erdtree# This is erdtree we pulled in from unstable in overlays/default.nix
        bottom
        exa
        bat

        killall
        glow
        pandoc
        jq;
    };

    # In case you use some software that does not have pre-defined modules in home-manager,
    # you can still create any config file you want using the home.file attribute set.
    # You can find more details about it in the option definition linked at the top.
    # file = { ... };
  };

  programs = {
    home-manager.enable = true;

    git = {
      userName = "Your Name";
      userEmail = "your@email.tld";
      # Notice we don't have `git` in the list of packages above, that's because
      # setting the option `programs.git.enable` to `true` will have the git module do that for us.
      enable = true;
      # Sane config defaults in my honest opinion
      extraConfig = {
        init.defaultBranch = "main";
        merge.conflictStyle = "diff3";
      };
    };

    # I recommend direnv for working with flakes and nix.
    direnv = {
      enable = true;
      enableZshIntegration = true;
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

  # This is like `home.file`, but putting files relative to `$XDG_CONFIG_HOME` rather than `$HOME`
  # xdg.configFile = { ... };
}
