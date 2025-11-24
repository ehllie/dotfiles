{
  inputs,
  pkgs,
  ...
}:
let
  inherit (pkgs) system;
  inherit (inputs)
    nil
    nixpkgs-unstable
    ;
  unstable = import nixpkgs-unstable { inherit system; };
in
{
  nixpkgs.overlays = [
    (import ./discord.nix)
    (import ./substitute-all-rec)
    (import ./try-import)
    (_: _: { nil = nil.packages.${system}.nil; })
    (_: prev: { })
    (import ./neovim.nix)
  ];
}
