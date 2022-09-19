external:
{ lib, ... }: {
  nixpkgs.overlays = lib.flatten
    [
      [
        (import ./discord.nix)
        (import ./tailwindcss-language-server.nix)
        (import ./substitute-all-rec)
      ]
      external
    ];
}
