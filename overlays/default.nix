{ inputs, lib, pkgs, ... }:
let
  inherit (pkgs) system;
  inherit (inputs)
    neovim
    ante
    nil
    docs-gen;
in
{
  nixpkgs.overlays =
    [
      (import ./discord.nix)
      (import ./node-packages { inherit lib; })
      (import ./substitute-all-rec)
      (import ./try-import)
      neovim.overlay
      ante.overlays.default
      (_: _: { nil = nil.packages.${system}.nil; })
      (_: _: { docs-gen = docs-gen.packages.${system}.docs-gen; })
    ];
}
