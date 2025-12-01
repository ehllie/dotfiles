{
  modulesPath,
  ezModules,
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    (modulesPath + "/virtualisation/qemu-vm.nix")
  ];

  networking = {
    useDHCP = true;
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB3C7/YxpoLu57b5XM2L0FVoRR5Qhju/9wxY082kmGCx"
  ];

  time.timeZone = "America/Toronto";
  system.stateVersion = "25.05";
  nixpkgs.hostPlatform = "aarch64-linux";
}
