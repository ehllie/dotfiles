{ pkgs, inputs, ... }:
let
  user = "foundryvtt";
  group = "foundryvtt";
  dataDir = "/var/lib/foundryvtt";

  foundryBuild = "344";
  foundryMajor = "13";
  foundryVersion = "${foundryMajor}.${foundryBuild}";
  foundryZip = pkgs.requireFile rec {
    sha256 = "1y0hssvmhb57p28nrkrsg7vqfb313n63zj01afn3ip93454avj76";
    name = "FoundryVTT-Node-${foundryVersion}.zip";
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
  mainPath = "main.js";
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
