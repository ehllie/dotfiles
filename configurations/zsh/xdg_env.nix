{ config, ... }:
{
  config.home = {
    sessionVariables = {

      XAUTHORITY = "${config.xdg.dataHome}/sddm/Xauthority";

      # $HOME/.ghcup
      GHCUP_USE_XDG_DIRS = true;

      # $HOME/.stack
      STACK_ROOT = "${config.xdg.dataHome}/stack";

      # $HOME/.cabal
      CABAL_CONFIG = "${config.xdg.dataHome}/cabal/config";
      CABAL_DIR = "${config.xdg.dataHome}/cabal";

      # $HOME/.rustup
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";

      # $HOME/.cargo
      CARGO_HOME = "${config.xdg.dataHome}/cargo";

      # $HOME/.python_history
      PYTHONSTARTUP = "${config.xdg.configHome}/python/pythonrc.py";

      # $HOME/.npmrc
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";

      # $HOME/.pnpmrc
      PNPM_HOME = "${config.xdg.dataHome}/pnpm";


      # $HOME/.lesshst
      LESSHISTFILE = "${config.xdg.cacheHome}/less/history";

      # $HOME/.kde4
      KDEHOME = "${config.xdg.configHome}/kde";

      # $HOME/.gtkrc-2.0
      GTK2_RC_FILES = "${config.xdg.configHome}/gtk-2.0/gtkrc";

      # $HOME/.gnupg
      GNUPGHOME = "${config.xdg.dataHome}/gnupg";

      # $HOME/.nv
      CUDA_CACHE_PATH = "${config.xdg.cacheHome}/nv";


      # $HOME/.inputrc
      INPUTRC = "${config.xdg.configHome}/readline/inputrc";

      # $HOME/.azure
      AZURE_CONFIG_DIR = "${config.xdg.dataHome}/azure";

      # $HOME/.aws
      AWS_SHARED_CREDENTIALS_FILE = "${config.xdg.configHome}/aws/credentials";
      AWS_CONFIG_FILE = "${config.xdg.configHome}/aws/config";

      # $HOME/.docker
      DOCKER_CONFIG = "${config.xdg.configHome}/docker";
    };
    shellAliases = {
      # $HOME/.yarnrc
      yarn = "yarn --use-yarnrc ${config.xdg.configHome}/yarn/config";
      # $HOME/wget-hsts
      wget = "wget - -hsts-file=${config.xdg.dataHome}/wget-hsts";
    };
  };
}
