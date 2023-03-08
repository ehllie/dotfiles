{ inputs, ... }:
let
  inherit (inputs) doom;
in
{
  imports = [ doom.hmModule ];
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d; # Directory containing your config.el, init.el
    # and packages.el files
  };
}
