{ utils, ... }:
let
  cond = utils.enumDefinitions [ "hardware" ] "dell-gram";
  utils' = utils.init { dfconf = utils.tryExtend { src = ./../secrets; default = "{}"; }; };
  enable = utils'.confVal [ "fido" "enable" ] false;
  credential = utils'.confVal [ "fido" "credential" ] "";
in
utils.mkDefs {
  nixosDefs = { config, lib, ... }: cond {
    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    services.xserver.videoDrivers = [ "modesetting" ];
    networking.useDHCP = lib.mkDefault true;

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
              inherit credential;
            };
          };
        };
      };
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/88D3-FEAF";
      fsType = "vfat";
    };
  };

}
