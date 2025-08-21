{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIX_ROOT";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-label/NIX_BOOT";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  };

  swapDevices = [{
    device = "/dev/disk/by-label/NIX_SWAP";
  }];
}
