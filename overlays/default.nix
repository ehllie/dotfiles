{ inputs, lib, pkgs, ... }:
let
  inherit (inputs) ante nil docs-gen;
in
{
  nixpkgs.overlays =
    [
      (import ./discord.nix)
      (import ./node-packages { inherit lib; })
      (import ./substitute-all-rec)
      ante.overlays.default
      nil.overlays.default
      docs-gen.overlays.default
    ];
}
