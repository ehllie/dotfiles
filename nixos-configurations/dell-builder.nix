{ config, inputs, lib, modulesPath, pkgs, ... }:
let inherit (config.sops.secrets) tunnel-credentials; in
{
  imports = [
    inputs.sops-nix.nixosModules.default
    (modulesPath + "/installer/scan/not-detected.nix")
  ];


  swapDevices = [
    { device = "/dev/disk/by-uuid/0c6eec1f-335f-448f-b5cc-85edd7f3018a"; }
  ];

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    kernelModules = [ "kvm-intel" ];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/0c0bc059-b437-4541-a5b7-40bf41a25bef";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/9890-6726";
      fsType = "vfat";
    };
  };

  powerManagement.cpuFreqGovernor = "performance";
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_IE.UTF-8";


  sops.secrets.tunnel-credentials = {
    owner = "cloudflared";
    group = "cloudflared";
    name = "tunnel-credentials.json";
    format = "binary";
    sopsFile = ../sops/builder/tunnel-credentials;
  };

  services = {
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };

    logind = {
      lidSwitchDocked = "ignore";
      lidSwitch = "ignore";
      lidSwitchExternalPower = "ignore";
    };

    cloudflared = {
      enable = true;
      tunnels."b0c2f8d9-05ba-4c16-8f03-36cd9bea5c52" = {
        credentialsFile = tunnel-credentials.path;
        default = "http_status:404";
        ingress = {
          "builder.ehllie.xyz".service = "ssh://127.0.0.1:22";
        };
      };

    };
  };

  networking = {
    hostName = "dell-builder";
    networkmanager.enable = true;
  };

  users.users = {
    builder = {
      isNormalUser = true;
      description = "Nix Builder";

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGWKSe5h51wlK0jkQidL1EVdIiswlMCjUjmOhN7USzbr ellie@EllMBP.local"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB3C7/YxpoLu57b5XM2L0FVoRR5Qhju/9wxY082kmGCx"
      ];
    };

    root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB3C7/YxpoLu57b5XM2L0FVoRR5Qhju/9wxY082kmGCx"
    ];
  };

  nix = {
    extraOptions = "experimental-features = nix-command flakes";

    settings.trusted-users = [
      "root"
      "builder"
    ];

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
  };

  environment.systemPackages = lib.attrValues {
    inherit (pkgs)
      cloudflared
      git
      neovim
      ;
  };

  system.stateVersion = "23.05";
}
