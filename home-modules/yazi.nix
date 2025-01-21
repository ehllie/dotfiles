{
  programs = {
    yazi = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };
    zsh.initExtra = "bindkey -s '^o' 'yy\\n'";
    tmux.extraConfig = ''
      set -g allow-passthrough on

      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM
    '';
  };
}
