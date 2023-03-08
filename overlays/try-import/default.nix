let
  tryImport = { stdenvNoCC, haskellPackages }:
    args@{ src, default ? "false", ... }:
    let
      valid = stdenvNoCC.mkDerivation {
        name = if args ? name then args.name else baseNameOf (toString args.src);
        nativeBuildInputs = [ haskellPackages.hnix ];
        builder = ./valid.sh;
        inherit src default;
      };
    in
    import valid;
in
self: super: { tryImport = super.callPackage tryImport { }; }
