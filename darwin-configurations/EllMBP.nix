{
  inputs,
  ezModules,
  pkgs,
  ...
}:
{

  imports = [
    ezModules.qemu-virt
    inputs.nix-rosetta-builder.darwinModules.default
  ];

  users.users.root.home = "/var/root";

  nixpkgs.hostPlatform = "aarch64-darwin";

  system = {
    stateVersion = 5;
    primaryUser = "ellie";
  };

  nix.distributedBuilds = true;
  nix-rosetta-builder = {
    enable = true;
    cores = 10;
    permitNonRootSshAccess = true;
  };
  # Enable this if rosetta-builder fails to build.
  # It needs to be bootstrapped with the linux-builder from nixpkgs binary cache
  # nix.linux-builder.enable = true;

}
