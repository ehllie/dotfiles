{ config, ... }:
{
  config.home = with config.xdg; {
    sessionVariables = {

      XAUTHORITY = "${dataHome}/sddm/Xauthority";

      # $HOME/.ghcup
      GHCUP_USE_XDG_DIRS = true;

      # $HOME/.stack
      STACK_ROOT = "${dataHome}/stack";

      # $HOME/.cabal
      CABAL_CONFIG = "${dataHome}/cabal/config";
      CABAL_DIR = "${dataHome}/cabal";

      # $HOME/.rustup
      RUSTUP_HOME = "${dataHome}/rustup";

      # $HOME/.cargo
      CARGO_HOME = "${dataHome}/cargo";

      # $HOME/.python_history
      PYTHONSTARTUP = "${configHome}/python/pythonrc.py";

      # $HOME/.npmrc
      NPM_CONFIG_USERCONFIG = "${configHome}/npm/npmrc";

      # $HOME/.pnpmrc
      PNPM_HOME = "${dataHome}/pnpm";


      # $HOME/.lesshst
      LESSHISTFILE = "${cacheHome}/less/history";

      # $HOME/.kde4
      KDEHOME = "${configHome}/kde";

      # $HOME/.gtkrc-2.0
      GTK2_RC_FILES = "${configHome}/gtk-2.0/gtkrc";

      # $HOME/.gnupg
      GNUPGHOME = "${dataHome}/gnupg";

      # $HOME/.nv
      CUDA_CACHE_PATH = "${cacheHome}/nv";


      # $HOME/.inputrc
      INPUTRC = "${configHome}/readline/inputrc";

      # $HOME/.azure
      AZURE_CONFIG_DIR = "${dataHome}/azure";

      # $HOME/.aws
      AWS_SHARED_CREDENTIALS_FILE = "${configHome}/aws/credentials";
      AWS_CONFIG_FILE = "${configHome}/aws/config";

      # $HOME/.docker
      DOCKER_CONFIG = "${configHome}/docker";
    };
    shellAliases = {
      # $HOME/.yarnrc
      yarn = "yarn --use-yarnrc ${configHome}/yarn/config";
      # $HOME/wget-hsts
      wget = "wget - -hsts-file=${dataHome}/wget-hsts";
    };
  };
}
