{
  modulesPath,
  ezModules,
  config,
  inputs,
  ...
}:
let
  secrets = config.sops.secrets;
  actual = config.services.actual;
in
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ezModules.partitions-by-label
    ezModules.swap-file
    ezModules.ssh-keys
    ezModules.actual-budget
    inputs.sops-nix.nixosModules.default
    ../overlays
  ];

  boot = {

    kernel.sysctl."vm.mmap_rnd_bits" = 18; # https://github.com/nixos/nixpkgs/issues/513512
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
  };

  time.timeZone = "Europe/Nuremberg";
  system.stateVersion = "25.05";
  nixpkgs = {
    hostPlatform = "aarch64-linux";
  };

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
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts =
      let
        cloudflareSSL = {
          forceSSL = true;
          sslCertificate = secrets.cloudflare-certificate.path;
          sslCertificateKey = secrets.cloudflare-pkey.path;
        };
      in
      {
        "budget.ehllie.xyz" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString actual.settings.port}";
            extraConfig = ''
              # Prevents header duplication between Upstream and Proxy
                proxy_hide_header Cross-Origin-Embedder-Policy;
                proxy_hide_header Cross-Origin-Opener-Policy;

                # Explicitly set mandatory security headers
                add_header Cross-Origin-Embedder-Policy "require-corp" always;
                add_header Cross-Origin-Opener-Policy "same-origin" always;
                add_header Origin-Agent-Cluster "?1" always;
            '';
          };
        }
        // cloudflareSSL;
      };
  };
}
