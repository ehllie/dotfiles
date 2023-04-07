# This is an example of how you might want to split up your modules.
# I left my personal zsh config to give a more concrete example of how you might do things.
{ config, pkgs, ... }:
let
  inherit (config.xdg) configHome cacheHome;
  inherit (pkgs)
    ranger
    powershell
    zsh-nix-shell
    zsh-vi-mode;
in
{
  home = {
    # powershell and ranger have no home-manager configration modules, so I install them "manually" here
    packages = [ ranger powershell ];
    shellAliases = {
      vim = "nvim";
      direnv-init = ''echo "use flake" >> .envrc && direnv allow'';
      ".." = "cd ..";
      "..." = "cd ../..";
      top = "btm";
      btop = "btm";
      ls = "exa";
      cat = "bat -pp";
      tree = "et --size-left --dirs-first --icons";
    };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  # This is how I configure my powershell using a `xdg.configFile` option.
  # This will create a file with the provided contents at
  # `$XDG_CONFIG_HOME/powershell/Microsoft.PowerShell_profile.ps1`
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
      dotDir = "${configHome}/zsh";
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      history.path = "${cacheHome}/zsh/history";

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
