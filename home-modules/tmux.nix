{ pkgs, config, lib, ... }:
let
  inherit (pkgs) tmuxPlugins;
in
{
  programs = {
    zsh.initExtra = lib.mkAfter ''
      if [ "$TMUX" = "" ]; then
        tmux_attach() {
            BUFFER="tmux a"
            zle accept-line
        }

        zle -N tmux_attach
        bindkey -M viins '^b' tmux_attach
      fi
    '';
    tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      mouse = true;
      newSession = true;
      terminal = "tmux-256color";

      extraConfig = ''
        set-option -g status-position top

        # Opens new windows in the current directory
        bind '"' split-window -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"

      '';

      plugins = [
        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = ''
            set -g @resurrect-dir ${config.xdg.stateHome}/tmux-ressurect
            set -g @resurrect-strategy-nvim 'session'
          '';
        }
        {
          plugin = tmuxPlugins.yank;
          extraConfig = ''
            set -g @yank_action 'copy-pipe'
          '';
        }
        {
          plugin = tmuxPlugins.catppuccin.overrideAttrs (_: {
            version = "unstable-2023-11-01";
            src = pkgs.fetchFromGitHub {
              owner = "catppuccin";
              repo = "tmux";
              rev = "47e33044b4b47b1c1faca1e42508fc92be12131a";
              hash = "sha256-kn3kf7eiiwXj57tgA7fs5N2+B2r441OtBlM8IBBLl4I=";
            };
          });
          extraConfig = ''
            set -g @catppuccin_flavour 'frappe'

            set -g @catppuccin_window_left_separator ""
            set -g @catppuccin_window_right_separator " "
            set -g @catppuccin_window_middle_separator " █"
            set -g @catppuccin_window_number_position "right"

            set -g @catppuccin_window_default_fill "number"
            set -g @catppuccin_window_default_text "#W"

            set -g @catppuccin_window_current_fill "number"
            set -g @catppuccin_window_current_text "#W"

            set -g @catppuccin_status_modules_right "session date_time"
            set -g @catppuccin_status_left_separator  " "
            set -g @catppuccin_status_right_separator ""
            set -g @catppuccin_status_right_separator_inverse "no"
            set -g @catppuccin_status_fill "icon"
            set -g @catppuccin_status_connect_separator "no"

            set -g @catppuccin_date_time_text "%a %-d %b %H:%M"
          '';
        }
        {
          plugin = tmuxPlugins.tmux-fzf;
          extraConfig = ''

            '';
        }
      ];
    };
  };
}
