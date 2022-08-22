{ config, pkgs, lib, inputs, ... }:
{

  imports = [ ./xdg_env.nix ];
  config = let cfg = config.dot-opts; in {
    home = {
      packages = with pkgs; [ ranger ];
      shellAliases =
        let
          flakeRebuild = cmd: loc: "sudo nixos-rebuild ${cmd} --flake ${loc}#${cfg.host}";
          updateDotfiles = "sudo nix flake lock --update-input dotfiles /etc/nixos";
        in
        {
          osflake-dry = "${updateDotfiles} && ${flakeRebuild "dry-activate" "/etc/nixos"}";
          osflake-switch = "${updateDotfiles} && ${flakeRebuild "switch" "/etc/nixos"}";
          locflake-dry = "${flakeRebuild "switch" "."} --impure";
          locflake-switch = "${flakeRebuild "switch" "."} --impure";
          vim = "nvim";
        };
      sessionPath = [ "${config.xdg.dataHome}/cargo" ];
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
          {
            name = "catppuccin-syntax-highlighting";
            file = "catppuccin-zsh-syntax-highlighting.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "catppuccin";
              repo = "zsh-syntax-highlighting";
              rev = "main";
              sha256 = "YV9lpJ0X2vN9uIdroDWEize+cp9HoKegS3sZiSpNk50=";
            };
          }
          {
            name = "zsh-syntax-highlighting";
            file = "zsh-syntax-highlighting.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "zsh-users";
              repo = "zsh-syntax-highlighting";
              rev = "master";
              sha256 = "YV9lpJ0X2vN9uIdroDWEize+cp9HoKegS3sZiSpNk50=";
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
