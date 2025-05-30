{ lib, pkgs, modulesPath, inputs, ezModules, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ezModules.foundry-vtt
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
    firewall.allowedUDPPorts = [ 24454 ]; # Simple Voice Chat
  };

  time.timeZone = "Europe/Frankfurt";
  i18n.defaultLocale = "en_IE.UTF-8";
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

  services = {
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };

  };
}
