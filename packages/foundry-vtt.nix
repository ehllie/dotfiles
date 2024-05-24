{ requireFile, unzip, runCommandLocal }:
let
  buildInfos = {
    "324" = {
      major = "12";
      sha256 = "1c3jsbj87rphhrcq38ixwlalr189h25x9rnxa1bgpbzqb6fngpjc";
    };
    "315" = {
      major = "11";
      sha256 = "00fwsc7bwrgmdzfk2savpsalcacgzlgizs0h0g6qby53f86m70m1";
    };
  };

  buildFoundryVTT = { build, major, sha256 ? "" }:
    let
      version = "${major}.${build}";
      name = "foundryvtt-${version}";
      zipFile = requireFile {
        name = "FoundryVTT-${version}.zip";
        sha256 = sha256;
        url = "https://foundryvtt.com/releases/download?build=${build}&platform=linux";
      };
    in
    runCommandLocal name
      {
        nativeBuildInputs = [ unzip ];
        passthru = { inherit allBuilds buildFoundryVTT; };
      }
      ''
        unzip ${zipFile} -d $out
      '';

  allBuilds = builtins.mapAttrs
    (build: info:
      buildFoundryVTT (info // { inherit build; })
    )
    buildInfos;
in

allBuilds."324"

