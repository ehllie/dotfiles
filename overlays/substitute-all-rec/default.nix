let
  substituteAllRec = { stdenvNoCC }: args:
    stdenvNoCC.mkDerivation ({
      name = if args ? name then args.name else baseNameOf (toString args.src);
      builder = ./substitute-all-rec.sh;
      inherit (args) src;
      preferLocalBuild = true;
      allowSubstitutes = false;
    } // args);
in
self: super: { substituteAllRec = super.callPackage substituteAllRec { }; }
