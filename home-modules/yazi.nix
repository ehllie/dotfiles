{
  programs = {
    yazi = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      shellWrapperName = "y";
    };
    zsh.initContent = "bindkey -s '^o' 'y\\n'";
    tmux.extraConfig = ''
      set -g allow-passthrough on

      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM
    '';
  };
}
