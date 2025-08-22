{ modulesPath, ezModules, config, inputs, pkgs, ... }:
let
  secrets = config.sops.secrets;
in
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ezModules.foundry-vtt
    ezModules.partitions-by-label
    ezModules.firefly-iii
    ezModules.mc-server
    inputs.sops-nix.nixosModules.default
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.availableKernelModules = [
      "xhci_pci"
      "virtio_pci"
      "virtio_scsi"
      "usbhid"
      "sr_mod"
    ];
  };

  networking = {
    hostName = "hetzner1";
    useDHCP = true;
    firewall = {
      allowedTCPPorts = [ 80 443 ];
      allowedUDPPorts = [ 24454 ]; # Simple Voice Chat
    };
  };

  time.timeZone = "America/New_York";
  system.stateVersion = "25.05";
  nixpkgs.hostPlatform = "x86_64-linux";

  sops.secrets = {
    cloudflare-certificate = {
      owner = config.services.nginx.user;
      group = config.services.nginx.group;
      name = "cloudflare-certificate.pem";
      sopsFile = ../sops/cloudflare.yaml;
      key = "cloudflare_origin_cert";
    };

    cloudflare-pkey = {
      owner = config.services.nginx.user;
      group = config.services.nginx.group;
      name = "cloudflare-certificate.key";
      sopsFile = ../sops/cloudflare.yaml;
      key = "cloudflare_origin_pkey";
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts =
      let
        cloudflareSSL = {
          forceSSL = true;
          sslCertificate = secrets.cloudflare-certificate.path;
          sslCertificateKey = secrets.cloudflare-pkey.path;
        };
      in
      {
        ${config.services.firefly-iii.virtualHost} = cloudflareSSL;

        ${config.services.firefly-iii-data-importer.virtualHost} = cloudflareSSL;

        "modpack.ehllie.xyz" = {
          locations."/" = {
            root = pkgs.vanilla-plus-manifest;
          };
        } // cloudflareSSL;

        "vtt.ehllie.xyz" = {
          locations."/" = {
            proxyWebsockets = true;
            proxyPass = "http://127.0.0.1:30000";
          };
          serverAliases = [ "www.vtt.ehllie.xyz" ];
        } // cloudflareSSL;
      };
  };
}
