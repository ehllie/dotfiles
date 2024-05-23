{ requireFile, stdenvNoCC, unzip }:
let
  build = "324";
in

stdenvNoCC.mkDerivation rec {
  pname = "foundryvtt";
  version = "12.${build}";
  src = requireFile {
    name = "FoundryVtt-${version}.zip";
    sha256 = "1c3jsbj87rphhrcq38ixwlalr189h25x9rnxa1bgpbzqb6fngpjc";
    url = "https://foundryvtt.com/releases/download?build=${build}&platform=linux";
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src -d $out
  '';
}
