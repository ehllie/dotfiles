{ utils, dfconf }:
# { config, dfconf, extra, lib, pkgs, ... }:
let cond = utils.enumDefinitions [ "shell" ] "zsh"; in
utils.mkDefs {

  nixosDefs = { pkgs, ... }: cond {
    environment = { pathsToLink = [ "/share/zsh" ]; };
    programs.zsh.enable = true;
    users.users.${dfconf.userName}.shell = pkgs.zsh;
  };

  homeDefs = { config, pkgs, ... }: cond {
    home.packages = [ pkgs.ranger ];

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
  };
}
