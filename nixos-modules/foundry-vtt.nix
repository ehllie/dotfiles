{ pkgs, inputs, ... }:
let
  user = "foundryvtt";
  group = "foundryvtt";
  dataDir = "/var/lib/foundryvtt";
  foundryvttPkg = inputs.self.packages.${pkgs.stdenv.system}.foundryvtt;
in
{
  environment.systemPackages = [ foundryvttPkg pkgs.nodejs ];
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
        ExecStart = "${pkgs.nodejs}/bin/node ${foundryvttPkg}/resources/app/main.js --dataPath='${dataDir}'";
      };
    };
  };
}
