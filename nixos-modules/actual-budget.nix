{ pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [
    80
    443
    3000
  ];
  services.actual = {
    package = pkgs.unstable.actual-server;
    enable = true;
    openFirewall = true;
    settings = {
      trustedProxies = [ "127.0.0.1" ];
    };
  };
}
