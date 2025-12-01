{ pkgs, ... }:
let
  inherit (pkgs.stdenv) isDarwin;
in
{
  home = {
    username = "ellie";
    stateVersion = "22.05";
    homeDirectory = if isDarwin then "/Users/ellie" else "/home/ellie";
  };

  programs.git.settings.user = {
    name = "Elizabeth Paź";
    email = "me@ehllie.xyz";
  };
}
