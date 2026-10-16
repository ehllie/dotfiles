{ pkgs, ... }: {
  home.sessionVariables.OPENCODE_DISABLE_LSP_DOWNLOAD = true;
  programs.opencode = {
    enable = true;
    package = pkgs.unstable.opencode;
  };
}
