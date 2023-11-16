{ inputs, pkgs, ... }:
let
  unstable-pkgs = import inputs.nixpkgs-unstable { inherit (pkgs.stdenv) system; };
  inherit (unstable-pkgs.darwin) linux-builder;
in
{

  users.users.root.home = "/var/root";

  nix = {
    distributedBuilds = true;

    buildMachines = [{
      hostName = "builder.ehllie.xyz";
      sshUser = "builder";
      system = "x86_64-linux";
      supportedFeatures = [ "kvm" "benchmark" "big-parallel" ];
      publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSU1mekdFaTJBTk5wdENta3h2ZXJSckdvWFY5R2Z2MWtya2ZtdElRbXV2NjAgcm9vdEBuaXhvcwo=";
      sshKey = "/etc/nix/dell-builder_ed25519";
      maxJobs = 8;
    }];

    linux-builder = {
      package = linux-builder;
      enable = true;
    };
  };
}
