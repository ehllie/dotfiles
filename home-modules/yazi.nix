{
  programs = {
    yazi = {
      enable = true;
      enableZshIntegration = true;
      # Uncomment after release 24.05, as currently enabling this causes deprecation warnings
      # enableNushellIntegration = true;
    };
    zsh.initExtra = "bindkey -s '^o' 'ya\n'";
    tmux.extraConfig = ''
      set -g allow-passthrough on

      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM
    '';
  };
}
