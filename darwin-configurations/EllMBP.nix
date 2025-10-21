{ inputs, ezModules, ... }:
{

  imports = [
    ezModules.qemu-virt
    inputs.nix-rosetta-builder.darwinModules.default
  ];

  virtualisation.qemu = {
    enable = true;
    guests.test = {
      guestConfiguration = inputs.self.nixosConfigurations.test;
      extraModules = [{
        virtualisation = {
          forwardPorts = [{
            from = "host";
            host.port = 2222;
            guest.port = 22;
          }];
          sharedDirectories.shows = {
            target = "/mnt/shows";
            source = "/Users/ellie/Movies/Shows";
          };
        };
      }];
    };
  };

  users.users.root.home = "/var/root";

  nixpkgs.hostPlatform = "aarch64-darwin";

  system = {
    stateVersion = 5;
    primaryUser = "ellie";
  };

  nix-rosetta-builder = {
    enable = true;
    cores = 10;
    permitNonRootSshAccess = true;
  };


  nix = {
    distributedBuilds = true;

    buildMachines = [ ];
    # linux-builder = {
    #   enable = true;
    #   # systems = [ "aarch64-linux" "x86_64-linux" ];
    #   # config = {
    #   #   virtualisation.cores = 10;
    #   #   boot.binfmt.emulatedSystems = [ "x86_64-linux" ];
    #   # };
    # };
  };
}
