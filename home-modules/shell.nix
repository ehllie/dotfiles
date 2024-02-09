{ config, osConfig, lib, pkgs, ... }:
let
  inherit (osConfig.networking) hostName;
  inherit (pkgs.stdenv) isDarwin isLinux;
  inherit (lib) attrValues;
  inherit (config.home) username;
  inherit (pkgs)
    zsh-nix-shell
    zsh-vi-mode;


  homeSwitch = "home-manager switch --flake '.#${username}@${hostName}'";
  nixosSwitch = "nixos-rebuild switch --flake '.#${hostName}'";
  darwinSwitch = "darwin-rebuild switch --flake '.#${hostName}'";

in
{
  home = {
    packages = attrValues {
      inherit (pkgs)
        powershell
        ranger;
    };

    shellAliases = {
      inherit homeSwitch;

      vim = "nvim";
      direnv-init = ''echo "use flake" >> .envrc'';
      ".." = "cd ..";
      "..." = "cd ../..";
      top = "btm";
      btop = "btm";
      ls = "eza";
      cat = "bat -pp";
      tree = "erd --layout inverted --icons --human";
    } // (
      if isDarwin then
        { inherit darwinSwitch; }
      else if isLinux then
        { inherit nixosSwitch; }
      else { }
    );

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      SOPS_AGE_KEY_FILE = config.xdg.configHome + "/sops/keys/age/keys.txt";
    };
  };


  xdg.configFile."powershell/Microsoft.PowerShell_profile.ps1".text = ''
    Invoke-Expression (&starship init powershell)
    Set-PSReadlineOption -EditMode Vi -ViModeIndicator Cursor
  '';

  programs = {
    atuin = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };

    carapace = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };

    zsh = {
      enable = true;
      defaultKeymap = "viins";
      dotDir = ".config/zsh";
      enableCompletion = true;
      syntaxHighlighting.enable = true;

      history = {
        ignoreSpace = true;
        path = "${config.xdg.cacheHome}/zsh/history";
      };

      localVariables = {
        VI_MODE_RESET_PROMPT_ON_MODE_CHANGE = true;
        VI_MODE_SET_CURSOR = true;
      };

      completionInit = ''
        autoload -U compinit && compinit
        zstyle ':completion:*' menu select
        zmodload zsh/complist
        compinit
        _comp_options+=(globdots)  # Include hidden files.
        unsetopt completealiases   # Include aliases.
      '';

      initExtra = ''
        source ${zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh
        source ${zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

        if [ "$TMUX" = "" ]; then
          exec tmux a
        fi
      '';
    };

    tmux =
      let inherit (pkgs) tmuxPlugins; in
      {
        enable = true;
        baseIndex = 1;
        clock24 = true;
        mouse = true;
        newSession = true;
        terminal = "tmux-256color";
        shell = "${config.programs.nushell.package}/bin/nu -l";

        extraConfig = ''
          set-option -g status-position top
          set-option -g default-command "${config.programs.nushell.package}/bin/nu -l"

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
            plugin = tmuxPlugins.continuum;
            extraConfig = ''
              set -g @continuum-restore 'on'
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
