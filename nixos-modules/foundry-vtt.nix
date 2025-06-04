{ pkgs, inputs, ... }:
let
  user = "foundryvtt";
  group = "foundryvtt";
  dataDir = "/var/lib/foundryvtt";

  foundryBuild = "343";
  foundryMajor = "12";
  foundryVersion = "${foundryMajor}.${foundryBuild}";
  foundryZip = pkgs.requireFile rec {
    sha256 = "11r3fl165lml3izr78igva9bq418749yqn66nq5hkg6a05zrav8b";
    name = "FoundryVTT-${foundryVersion}.zip";
    message = ''
      ${name} cannot be downloaded automatically.
      Please go to https://foundryvtt.com/releases/download?build=${foundryBuild}&platform=node to download it yourself.
      Afterwards add it to the nix store with 
        nix-store --add-fixed sha256 \$HOME/Downloads/${name}
    '';
  };
  foundryPackage = pkgs.runCommand "foundryvtt-${foundryVersion}"
    {
      nativeBuildInputs = [ pkgs.unzip ];
    }
    ''
      unzip ${foundryZip} -d $out
    ''
  ;
  mainPath = "resources/app/main.js";
in
{
  environment.systemPackages = [ foundryPackage pkgs.nodejs ];
  # networking.firewall.allowedUDPPorts = [ 30000 ];

  users = {
    groups.${group} = { };
    users.${user} = {
      inherit group;
      isSystemUser = true;
    };
  };

  systemd = {
    tmpfiles.rules = [
      "d ${dataDir} 0755 ${user} ${group} -"
    ];

    services.foundryvtt = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        User = user;
        Restart = "on-failure";
        RestartSec = "5";
        TimeoutStartSec = "10";
        ExecStart = "${pkgs.nodejs}/bin/node ${foundryPackage}/${mainPath} --dataPath='${dataDir}'";
      };
    };
  };
}
