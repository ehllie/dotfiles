external:
{ lib, ... }: {
  nixpkgs.overlays = lib.flatten
    [
      [
        (import ./discord.nix)
        (import ./node-packages { inherit lib; })
        (import ./substitute-all-rec)
      ]
      external
    ];
}
