{ inputs, lib, pkgs, ... }:
let
  inherit (pkgs) system;
  inherit (inputs)
    ante
    nil
    nixpkgs-unstable
    docs-gen;
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
      (_: _: { nil = nil.packages.${system}.nil; })
      (_: _: { docs-gen = docs-gen.packages.${system}.docs-gen; })
      (_: prev: {
        inherit (unstable)
          erdtree;
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
