{ utils, ... }:
let
  cond = utils.enumDefinitions [ "hardware" ] "desktop";
  dfconf = utils.tryExtend { src = ./../secrets; default = "{}"; };
in
utils.mkDefs {
  nixosDefs = { config, lib, ... }:
    let
      enable = lib.attrByPath [ "fido" "enable" ] false dfconf;
      credential = lib.attrByPath [ "fido" "credential" ] "" dfconf;
    in
    cond {
      networking.useDHCP = lib.mkDefault true;
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      programs.steam.enable = true;

      boot = {
        kernelModules = [ "kvm-amd" ];
        extraModulePackages = [ ];

        initrd = {
          kernelModules = [ "dm-snapshot" ];
          availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];

          luks = {
            fido2Support = enable;

            devices.luks1 = {
              device = "dev/disk/by-uuid/2c5bcbcf-7615-42cf-ae75-f83a992605a9";
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
        device = "/dev/disk/by-uuid/8CA4-CBD3";
        fsType = "vfat";
      };

      services.xserver = {
        videoDrivers = [ "nvidia" ];
        displayManager.sessionCommands = ''
          xrandr --output DP-4 --mode 2560x1440 --refresh 144
          xrandr --output HDMI-0 --right-of DP-4 --rotate left
        '';
      };
    };
}
