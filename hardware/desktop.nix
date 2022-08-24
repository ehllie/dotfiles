{ config, lib, pkgs, modulesPath, ... }:
let cfg = config.dot-opts.hardware; in {

  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  options.dot-opts.hardware.machine = with lib; mkOption {
    type = with types; nullOr (enum [ "desktop" ]);
  };

  config = lib.mkIf (cfg.machine == "desktop") {

    boot = {
      kernelModules = [ "kvm-amd" ];
      extraModulePackages = [ ];
      initrd = {
        kernelModules = [ "dm-snapshot" ];
        availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
        luks = {
          fido2Support = cfg.fido.enable;
          devices.luks1 = {
            device = "dev/disk/by-uuid/2c5bcbcf-7615-42cf-ae75-f83a992605a9";
            preLVM = true;
            fido2 = lib.mkIf (cfg.fido.enable) {
              passwordLess = true;
              credential = cfg.fido.credential;
            };
          };
        };
      };
    };

    fileSystems = {
      "/" = { device = "/dev/vg1/root"; fsType = "ext4"; };
      "/boot" = { device = "/dev/disk/by-uuid/8CA4-CBD3"; fsType = "vfat"; };
      "/home" = { device = "/dev/vg1/home"; fsType = "ext4"; };
    };

    swapDevices = [{ device = "/dev/vg1/swap"; }];

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
    # networking.interfaces.wlp36s0.useDHCP = lib.mkDefault true;

    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
