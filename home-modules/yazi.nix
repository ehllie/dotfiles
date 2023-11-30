{
  programs = {
    yazi = {
      enable = true;
      enableZshIntegration = true;
    };
    zsh.initExtra = "bindkey -s '^o' 'ya\n'";
    tmux.extraConfig = ''
      set -g allow-passthrough on

      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM
    '';
  };
}
