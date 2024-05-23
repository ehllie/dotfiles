{ pkgs, inputs, ... }:
let
  user = "foundryvtt";
  group = "foundryvtt";
  dataDir = "/var/lib/foundryvtt";
  pkg = inputs.self.packages.${pkgs.stdenv.system}.foundry-vtt;
in
{
  environment.systemPackages = [ pkg pkgs.nodejs ];
  networking.firewall.allowedUDPPorts = [ 30000 ];

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
        WorkingDirectory = pkg;
        ExecStart = "${pkgs.nodejs}/bin/node resources/app/main.js --dataPath='${dataDir}'";
      };
    };
  };
}
