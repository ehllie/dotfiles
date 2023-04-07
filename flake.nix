{
  description = "Basic nix flake config";

  # Flake schema reference: https://nixos.wiki/wiki/Flakes
  inputs = {
    # Using both a stable and unstable nixpkgs is a good idea, as it allows you to
    # use the latest packages for some things, while still having a stable base.
    # When a new version of nixpkgs comes out, like 23.05, you just need to change the
    # nixpkgs.url to point to the new version, and then run `nix flake update` to update.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    darwin = { url = "github:lnl7/nix-darwin/master"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  # Outputs is a function that as its arguments takes the optupts of specified flakes,
  # as well as its own output (self). In case the syntax is unclear, here's the
  # nix function syntax referrence: https://nixos.wiki/wiki/Overview_of_the_Nix_Language#Functions
  outputs =
    { self
    , home-manager
    , darwin
    , ...
    }@inputs:
    let
      # The `inherit` statement is somewhat equivalent to python's `from darwin.lib import darwinSystem`.
      # It can also be used in attrsets,it's used that way later in this file in the homeManagerConfiguration call.
      inherit (darwin.lib) darwinSystem;
      inherit (home-manager.lib) homeManagerConfiguration;
      # Sharing the packages used in the system with the ones used in home-manager,
      # so as not to inflate the store with duplicate packages.
      pkgs = self.darwinConfigurations.${hostname}.pkgs;

      # Replace these with your own username and hostname.
      username = "your-username";
      hostname = "your-hostname";
    in
    {
      # This is not part of the officaial flake schema, but it's the default output used by home-manager.
      # Calling `home-manager switch --flake .` will use the output will try to use the config defined under
      # `homeConfigurations.${USER}@${HOST}` (USER and HOST being shell env variables). You can also specify
      # it explicitly with `home-manager switch --flake '.#your-username@your-hostname'`
      homeConfigurations = {
        "${username}@${hostname}" = homeManagerConfiguration {
          inherit pkgs;
          # This will import the file defined under ./home/default.nix
          modules = [ ./home ];
          # This lets us use the flake `inputs` inside our modules.
          extraSpecialArgs = { inherit inputs; };
        };
      };

      # Analogous to the homeConfigurations output, this is just the default output used by nix-darwin.
      # It will likewise try to use the config defined under `darwinConfigurations.${HOST}` (HOST being a shell env variable),
      # unless you explicitly specify it with `darwin-rebuild switch --flake .#your-hostname`.
      darwinConfigurations = {
        ${hostname} = darwinSystem {
          # Set system to aarch64-darwin for Apple Silicon and x86_64-darwin for Intel Macs
          system = "aarch64-darwin";
          # Importing the darwin and overlays modules from ./darwin/default.nix and ./overlays/default.nix.
          # They don't need to be separate files, but in case you want to configure a nixos machine at some point,
          # you can reuse the overlays module for a lot things.
          modules = [ ./darwin ./overlays ];
          # darwinSystem function uses specialArgs rather than extraSpecialArgs, but it does the same thing.
          specialArgs = { inherit inputs; };
        };
      };
    };
}
