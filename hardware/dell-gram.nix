{ config, lib, pkgs, modulesPath, ... }:
let cfg = config.dot-opts.hardware; in {

  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  options.dot-opts.hardware.machine = with lib; mkOption {
    type = with types; nullOr (enum [ "dell-gram" ]);
  };

  config = lib.mkIf (cfg.machine == "dell-gram") {

    boot = {
      kernelModules = [ "kvm-intel" ];
      extraModulePackages = [ ];
      initrd = {
        kernelModules = [ "dm-snapshot" ];
        availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
        luks = {
          fido2Support = cfg.fido.enable;
          devices.luks1 = {
            device = "/dev/disk/by-uuid/a9d1cae3-cf72-4c56-8d2c-cba89ffbdb55";
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
      "/boot" = { device = "/dev/disk/by-uuid/88D3-FEAF"; fsType = "vfat"; };
    };

    swapDevices = [{ device = "/dev/vg1/swap"; }];

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
