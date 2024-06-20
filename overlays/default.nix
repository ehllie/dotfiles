{ inputs, lib, pkgs, ... }:
let
  inherit (pkgs) system;
  inherit (inputs)
    ante
    nil
    yazi
    nixpkgs-unstable;
  unstable = import nixpkgs-unstable { inherit system; };
in
{
  nixpkgs.overlays =
    [
      (import ./discord.nix)
      (import ./node-packages { inherit lib; })
      (import ./substitute-all-rec)
      (import ./try-import)
      (import ./neovim.nix)
      ante.overlays.default
      yazi.overlays.default
      (_: _: { nil = nil.packages.${system}.nil; })
      (_: prev: {
        inherit (unstable)
          erdtree
          neovim
          ;
        nodePackages = prev.nodePackages //
          {
            inherit (unstable.nodePackages)
              prettier
              prettier-plugin-toml
              svelte-language-server
              volar;
          };
      })
    ];
}
