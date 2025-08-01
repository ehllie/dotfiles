{ lib, pkgs, modulesPath, ezModules, config, inputs, ... }:
let
  secrets = config.sops.secrets;
in
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ezModules.foundry-vtt
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

  swapDevices = [{
    device = "/dev/disk/by-uuid/218337e4-3f20-46c2-8422-e81762af1d80";
  }];

  networking = {
    hostName = "hetzner0";
    useDHCP = true;
    firewall = {
      allowedTCPPorts = [ 80 443 ];
      allowedUDPPorts = [ 24454 ]; # Simple Voice Chat
    };
  };

  time.timeZone = "Europe/Frankfurt";
  i18n = {
    defaultLocale = "en_IE.UTF-8";
    extraLocales = [
      "en_GB.UTF-8/UTF-8"
      "en_CA.UTF-8/UTF-8"
      "pl_PL.UTF-8/UTF-8"
    ];
  };
  system.stateVersion = "23.11";

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = "aarch64-linux";
  };

  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    gc = {
      automatic = true;
      dates = "weekly";
    };
  };

  environment.systemPackages = lib.attrValues {
    inherit (pkgs)
      git
      neovim
      tmux
      wget
      ;
  };

  sops.secrets = {
    firefly-app-secret = {
      owner = config.services.firefly-iii.user;
      group = config.services.firefly-iii.group;
      name = "firefly-app-secret";
      sopsFile = ../sops/firefly.json;
      format = "json";
      key = "app_secret";
    };

    nordigen_id = {
      owner = config.services.firefly-iii-data-importer.user;
      group = config.services.firefly-iii-data-importer.group;
      name = "gocardless_id";
      sopsFile = ../sops/firefly.json;
      format = "json";
      key = "nordigen_id";
    };

    nordigen_key = {
      owner = config.services.firefly-iii-data-importer.user;
      group = config.services.firefly-iii-data-importer.group;
      name = "gocardless_key";
      sopsFile = ../sops/firefly.json;
      format = "json";
      key = "nordigen_key";
    };

    cloudflare-certificate = {
      owner = config.services.nginx.user;
      group = config.services.nginx.group;
      name = "cloudflare-certificate.pem";
      sopsFile = ../sops/hetzner0.yaml;
      key = "cloudflare_origin_cert";
    };

    cloudflare-pkey = {
      owner = config.services.nginx.user;
      group = config.services.nginx.group;
      name = "cloudflare-certificate.key";
      sopsFile = ../sops/hetzner0.yaml;
      key = "cloudflare_origin_pkey";
    };


  };

  services = {
    firefly-iii = {
      enable = true;
      enableNginx = true;
      virtualHost = "budget.ehllie.xyz";
      settings = {
        SITE_OWNER = "ffadmin@ehllie.xyz";
        MAIL_FROM = "ffadmin@ehllie.xyz";
        MAIL_MAILER = "log";
        APP_DEBUG = "true";
        APP_LOG_LEVEL = "debug";
        LOG_CHANNEL = "stack";
        APP_KEY_FILE = secrets.firefly-app-secret.path;
      };
    };

    firefly-iii-data-importer = rec {
      enable = true;
      virtualHost = "import.ehllie.xyz";
      enableNginx = true;
      settings = rec {
        TRUSTED_PROXIES = "*";
        FIREFLY_III_URL = "https://${config.services.firefly-iii.virtualHost}";
        FIREFLY_III_CLIENT_ID = "3";
        VANITY_URL = FIREFLY_III_URL;
        SIMPLEFIN_CORS_ORIGIN_URL = "https://${virtualHost}";
        NORDIGEN_ID_FILE = secrets.nordigen_id.path;
        NORDIGEN_KEY_FILE = secrets.nordigen_key.path;
      };
    };

    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };

    nginx = {
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
          } // cloudflareSSL;
        };
    };
  };
}
