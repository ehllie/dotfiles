{ inputs, pkgs, ... }:
let
  unstable-pkgs = import inputs.nixpkgs-unstable { inherit (pkgs) system; };
in
{
  networking.firewall.allowedTCPPorts = [
    80
    443
    3000
  ];
  services.actual = {
    package = unstable-pkgs.actual-server;
    enable = true;
    openFirewall = true;
    settings = {
      trustedProxies = [ "127.0.0.1" ];
    };
  };
}
