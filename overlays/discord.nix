self: super: {
  discord =
    let
      nss =
        if super.stdenv.buildPlatform.isLinux
        then { nss = super.nss_latest; }
        else { };
    in
    super.discord.override ({ withOpenASAR = true; } // nss);
}
