{ inputs, lib, pkgs, ... }:
let
  inherit (pkgs) system;
  inherit (inputs)
    ante
    nil
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
      ante.overlays.default
      (_: _: { nil = nil.packages.${system}.nil; })
      (_: prev: {
        inherit (unstable)
          erdtree
          neovim-unwrapped
          gleam
          ;

        nodePackages = prev.nodePackages //
          {
            inherit (unstable.nodePackages)
              prettier
              prettier-plugin-toml
              svelte-language-server
              ;
          };
      })
      (import ./neovim.nix)
    ];
}
