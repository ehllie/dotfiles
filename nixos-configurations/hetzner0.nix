{
  modulesPath,
  ezModules,
  config,
  inputs,
  ...
}:
let
  secrets = config.sops.secrets;
in
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ezModules.foundry-vtt
    ezModules.firefly-iii
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

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/79136d92-c8e9-4bb3-83f3-6c4cf33ace32";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/7793-2667";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/218337e4-3f20-46c2-8422-e81762af1d80";
    }
  ];

  networking = {
    hostName = "hetzner0";
    useDHCP = true;
    firewall = {
      allowedTCPPorts = [
        80
        443
      ];
      allowedUDPPorts = [ 24454 ]; # Simple Voice Chat
    };
  };

  time.timeZone = "Europe/Frankfurt";
  system.stateVersion = "23.11";
  nixpkgs.hostPlatform = "aarch64-linux";

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

        "vtt.ehllie.xyz" = {
          locations."/" = {
            proxyWebsockets = true;
            proxyPass = "http://127.0.0.1:30000";
          };
          serverAliases = [ "www.vtt.ehllie.xyz" ];
        }
        // cloudflareSSL;
      };
  };
}
