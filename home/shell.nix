{ config, lib, pkgs, ... }:
let
  inherit (pkgs.stdenv) isDarwin;
  inherit (lib) attrValues;
  inherit (config.home) homeDirectory;
  inherit (pkgs)
    zsh-nix-shell
    zsh-vi-mode;

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
      direnv exec . "$SHELL"
    else
      direnv exec . "$SHELL" -c "SHELL=$SHELL; ${presence-fix} $*"
    fi
  '';

  rebuild = if isDarwin then "darwin-rebuild" else "sudo nixos-rebuild";
  remote-op = "${remote-op-pkg}/bin/remote-op";
  repoDir = "${homeDirectory}/Code/dotfiles/home/neovim/nvim";
  hostName = "\${$(hostname)%%.*}";
  flakeRebuild = cmd: loc: "${rebuild} ${cmd} --flake ${repoDir}#${hostName}";

  osflake-dry = "${remote-op} ${flakeRebuild "dry-activate" "."} --option tarball-ttl 0";
  osflake-switch = "${remote-op} ${flakeRebuild "switch" "."} --option tarball-ttl 0";
  locflake-dry = "${flakeRebuild "dry-activate" repoDir}" + (if isDarwin then "" else " --fast");
  locflake-switch = "${flakeRebuild "switch" repoDir}" + (if isDarwin then "" else " --fast");

in
{
  home = {
    packages = attrValues {
      inherit (pkgs)
        powershell
        ranger;
      inherit develop;
    };

    shellAliases = {
      inherit
        locflake-switch
        osflake-switch;
      vim = "nvim";
      direnv-init = ''echo "use flake" >> .envrc && direnv allow'';
      ".." = "cd ..";
      "..." = "cd ../..";
      top = "btm";
      btop = "btm";
      ls = "exa";
      cat = "bat -pp";
      tree = "erd --dirs-first --icons --human";
    } // (
      if isDarwin then
        { } else {
        inherit
          locflake-dry
          osflake-dry;
      }
    );

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };


  xdg.configFile."powershell/Microsoft.PowerShell_profile.ps1".text = ''
    Invoke-Expression (&starship init powershell)
    Set-PSReadlineOption -EditMode Vi -ViModeIndicator Cursor
  '';

  programs = {
    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
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

      initExtra = ''
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
      '';
    };
  };
}
