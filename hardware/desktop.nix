{ config, lib, myLib, ... }:
let cfg = config.dotfiles; in {
  options.dotfiles.hardware = myLib.mkEnumOption "desktop";

  config = lib.mkIf (cfg.hardware == "desktop") {
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

    fileSystems."/boot" = { device = "/dev/disk/by-uuid/8CA4-CBD3"; fsType = "vfat"; };

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
    # networking.interfaces.wlp36s0.useDHCP = lib.mkDefault true;

    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    services.xserver = {
      videoDrivers = [ "nvidia" ];
      displayManager.sessionCommands = ''
        xrandr --output DP-4 --mode 2560x1440 --refresh 144
        xrandr --output HDMI-0 --right-of DP-4 --rotate left
      '';
    };

    programs.steam.enable = true;
  };
}
