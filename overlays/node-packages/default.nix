{ lib }:

let
  inherit (lib) extends makeExtensible;

  nodePackages = import ./composition.nix;

  extensions = import ./overrides.nix;
in

self: super: {
  nodePackages =
    let
      merged = super.nodePackages // (nodePackages
        { pkgs = super; inherit (super) nodejs; });
    in
    makeExtensible (extends extensions (final: merged));
}
