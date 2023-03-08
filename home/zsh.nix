{ config, lib, pkgs, ... }:
let
  inherit (pkgs.stdenv) isDarwin;
  inherit (lib) attrValues;
  inherit (config.home) homeDirectory;

  remote-op-pkg = pkgs.writeShellScriptBin "remote-op" ''
    dir=$(mktemp -dt tmp.dotfiles-XXXXXX)
    git clone https://github.com/ehllie/dotfiles.git --depth 1 $dir
    cd $dir
    git-crypt unlock
    eval "$@"
    cd
    rm -rf $dir
  '';

  presence-fix = if isDarwin then "TMPDIR=$TMPDIR;" else "";
  develop = pkgs.writeShellScriptBin "develop" ''
    if [ -z "$1" ]; then
      nix develop -c "$SHELL"
    else
      nix develop -c "$SHELL" -c "SHELL=$SHELL; ${presence-fix} $*"
    fi
  '';

  rebuild = if isDarwin then "darwin-rebuild" else "sudo nixos-rebuild";
  remote-op = "${remote-op-pkg}/bin/remote-op";
  repoDir = "${homeDirectory}/Code/dotfiles/home/neovim/nvim";
  hostName = "\${$(hostname)%%.*}";
  flakeRebuild = cmd: loc: "sudo ${rebuild} ${cmd} --flake ${repoDir}#${hostName}";

  osflake-dry = "${remote-op} ${flakeRebuild "dry-activate" "."} --option tarball-ttl 0";
  osflake-switch = "${remote-op} ${flakeRebuild "switch" "."} --option tarball-ttl 0";
  locflake-dry = "${flakeRebuild "dry-activate" repoDir} --fast";
  locflake-switch = "${flakeRebuild "switch" repoDir} --fast";
  vim = "nvim";

in
{
  home = {
    packages = attrValues {
      inherit (pkgs)
        ranger;
      inherit develop;
    };

    shellAliases = {
      inherit
        locflake-switch
        osflake-switch
        vim;
    } // (
      if isDarwin then
        { } else {
        inherit
          locflake-dry
          osflake-dry;
      }
    );
  };

  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";
    dotDir = ".config/zsh";
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    history.path = "${config.xdg.cacheHome}/zsh/history";

    localVariables = {
      VI_MODE_RESET_PROMPT_ON_MODE_CHANGE = true;
      VI_MODE_SET_CURSOR = true;
    };

    completionInit = ''
      autoload -U compinit && compinit
      zstyle ':completion:*' menu select
      zmodload zsh/complist
      compinit
      _comp_options+=(globdots)		# Include hidden files.
      unsetopt completealiases		# Include aliases.
    '';

    initExtra = with pkgs; ''
      source ${spaceship-prompt}/lib/spaceship-prompt/spaceship.zsh
      source ${nix-zsh-completions}/share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh
      source ${zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh
      source ${zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

      # Use ranger to switch directories and bind it to ctrl-o
      rangercd () {
        tmp="$(mktemp)"
        ranger --choosedir="$tmp" "$@"
        if [ -f "$tmp" ]; then
          dir="$(cat "$tmp")"
          rm -f "$tmp"
          [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
        fi
      }
      bindkey -s '^o' 'rangercd\n'

      prompt_nix_shell_setup
    '';
  };
}
