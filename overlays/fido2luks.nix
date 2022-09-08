self: super:
let
  patch = super.fetchpatch {
    name = "libcryptsetup-rs.patch";
    url = "https://github.com/shimunn/fido2luks/commit/c87a9bbb4cbbe90be7385d4bc2946716c593b91d.diff";
    sha256 = "2IWz9gcEbXhHlz7VWoJNBZfwnJm/J3RRuXg91xH9Pl4=";
  };
in
{
  fido2luks = super.fido2luks.overrideAttrs (oldAttrs: {
    patches = [ patch ];
    cargoDeps = oldAttrs.cargoDeps.overrideAttrs (_: {
      patches = [ patch ];
      outputHash = "U/2dAmFmW6rQvojaKSDdO+/WzajBJmhOZWvzwdiYBm0=";
    });
    meta.broken = false;
  });
}
