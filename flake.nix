{
  description = "An alright configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nur.url = github:nix-community/NUR;
    home-manager = { url = github:nix-community/home-manager; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = inputs@{ self, nur, home-manager, nixpkgs, ... }:
    {

      mkConfig = { hwConfig }: {
        nixos-gram = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./host.nix
            # Include the results of the hardware scan.
            nur.nixosModules.nur
            hwConfig
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              nixpkgs.config.allowUnfree = true;
              home-manager.users.ellie = { imports = [ ./configurations/home.nix ]; };
            }
          ];
        };
      };

    };
}
