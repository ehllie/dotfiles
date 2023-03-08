{ config, lib, pkgs, ... }:
let
  inherit (pkgs) tryImport;
  secrets = tryImport { src = ../secrets; };
  enable = if secrets == true then true else false;
in
{
  powerManagement.cpuFreqGovernor = "powersave";
  networking.hostName = "dell-gram";

  boot = {
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];

    initrd = {
      kernelModules = [ "dm-snapshot" ];
      availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];

      luks = {
        fido2Support = enable;

        devices.luks1 = {
          device = "/dev/disk/by-uuid/a9d1cae3-cf72-4c56-8d2c-cba89ffbdb55";
          preLVM = true;

          fido2 = lib.mkIf enable {
            passwordLess = true;
            inherit (secrets) credential;
          };
        };
      };
    };
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/88D3-FEAF";
    fsType = "vfat";
  };

  services = {
    xserver.videoDrivers = [ "modesetting" ];
    samba-wsdd.enable = true; # make shares visible for windows 10 clients

    samba = {
      enable = true;
      openFirewall = true;

      extraConfig = ''
        guest account = ellie
        map to guest = Bad User

        follow symlinks = yes
        unix extensions = no
        wide links = yes

        load printers = no
        printcap name = /dev/null

        log file = /var/log/samba/client.%I
        log level = 2
      '';

      shares = {
        Code = {
          "path" = "/home/ellie/Code/samba";
          "guest ok" = "no";
          "read only" = "no";
        };
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 5357 ]; # wsdd
    allowedUDPPorts = [ 3702 ]; # wsdd
  };
}
