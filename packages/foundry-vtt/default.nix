{ requireFile, unzip, runCommand }:
let
  buildInfos = builtins.fromJSON (builtins.readFile ./builds.json);

  buildFoundryVTT = { build, major, sha256 ? "" }:
    let
      version = "${major}.${build}";
      name = "foundryvtt-${version}";
      zipFile = requireFile rec {
        name = "FoundryVTT-${version}.zip";
        inherit sha256;
        message = ''
          ${name} cannot be downloaded automatically.
          Please go to https://foundryvtt.com/releases/download?build=${build}&platform=linux to download it yourself.
          Afterwards add it to the nix store with 
            nix-store --add-fixed sha256 \$HOME/Downloads/${name}
        '';
      };
    in
    runCommand name
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

allBuilds."331"

