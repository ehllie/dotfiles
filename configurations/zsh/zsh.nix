{ config, pkgs, lib, inputs, ... }:
{

  config = {
    home = {
      packages = with pkgs; [ ranger ];
      sessionPath = [ ];
      sessionVariables = { };
      shellAliases = {
        osflake-update = "sudo nix flake update /etc/nixos";
        osflake-dry = "sudo nixos-rebuild dry-activate --flake /etc/nixos#$HOST";
        osflake-switch = "sudo nixos-rebuild switch --flake /etc/nixos#$HOST";
        osflake-iter = "sudo nix flake update /etc/nixos && sudo nixos-rebuild switch --flake /etc/nixos#$HOST";
        vim = "nvim";
      };
    };

    programs.zsh = {
      enable = true;
      history = {
        path = "$XDG_CACHE_HOME/zsh/history";
      };
      dotDir = ".config/zsh";

      localVariables = {
        VI_MODE_RESET_PROMPT_ON_MODE_CHANGE = true;
        VI_MODE_SET_CURSOR = true;
      };
      enableCompletion = true;
      completionInit = ''
        autoload -U compinit && compinit
        zstyle ':completion:*' menu select
        zmodload zsh/complist
        compinit
        _comp_options+=(globdots)		# Include hidden files.
        unsetopt completealiases		# Include aliases.
      '';
      defaultKeymap = "viins";
      initExtra = ''
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


      plugins =
        [
          {
            name = "nix-zsh-completions";
            file = "nix-zsh-completions.plugin.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "spwhitt";
              repo = "nix-zsh-completions";
              rev = "0.4.4";
              sha256 = "Djs1oOnzeVAUMrZObNLZ8/5zD7DjW3YK42SWpD2FPNk=";
            };
          }
          {
            name = "zsh-nix-shell";
            file = "nix-shell.plugin.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "chisui";
              repo = "zsh-nix-shell";
              rev = "v0.5.0";
              sha256 = "IT3wpfw8zhiNQsrw59lbSWYh0NQ1CUdUtFzRzHlURH0=";
            };
          }
          {
            name = "spaceship-zsh-theme";
            file = "spaceship.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "pascaldevink";
              repo = "spaceship-zsh-theme";
              rev = "master";
              sha256 = "Mj5we+tOPgQ/JLBgplDG3qln1RMsm3Ir0c9URcP3AQY=";
            };
          }
        ];
      oh-my-zsh = {
        enable = true;
        plugins = [ "poetry" "vi-mode" ];
      };
    };
  };
}
