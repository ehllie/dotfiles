self: super: {
  fido2luks = super.fido2luks.overrideAttrs (oldAttrs: {
    patches = [ ./libcryptsetup-rs.patch ];
    cargoDeps = oldAttrs.cargoDeps.overrideAttrs (_: {
      patches = [ ./libcryptsetup-rs.patch ];
      outputHash = "U/2dAmFmW6rQvojaKSDdO+/WzajBJmhOZWvzwdiYBm0=";
    });
    meta.broken = false;
  });
}
