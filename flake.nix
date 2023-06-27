{
  description = "An alright configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nil.url = "github:oxalica/nil";
    docs-gen.url = "git+ssh://git@github.com/SayInvest/docs-gen?ref=release-0.1";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ante = {
      url = "github:jfecher/ante";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , darwin
    , ...
    }@inputs:
    let
      inherit (builtins) listToAttrs pathExists;
      inherit (nixpkgs.lib) concatMap mapAttrsToList nixosSystem optionals;
      inherit (darwin.lib) darwinSystem;
      inherit (home-manager.lib) homeManagerConfiguration;


      # Import a module of a given name if it exists.
      # First check for a `.nix` file, then a directory.
      importModule = name:
        let
          file = self + "/${name}.nix";
          dir = self + "/${name}";
        in
        if pathExists file then file
        else if pathExists dir then dir
        else { };

      # Generates an atterset of nixosConfigurations or darwinConfigurations.
      # systemBuilder: The function to use to build the system. i.e. nixosSystem or darwinSystem
      # defaultModule: The module to always include in the system. i.e. ./nixos or ./darwin
      # hosts: A list of host declarations. i.e. [ { host = "foo"; system = "aarch64-darwin"; } ... ]
      systemsWith = systemBuilder: defaultModule: hosts:
        listToAttrs (map
          ({ host, system }: {
            name = host;
            value = systemBuilder {
              inherit system;
              specialArgs = { inherit inputs; };
              modules = [
                defaultModule
                ./overlays
                (importModule "hosts/${host}")
              ];
            };
          })
          hosts);

      # Combined list attrsets containing the hostname
      # and it's configuration for all nixos and darwin systems.
      allHosts = mapAttrsToList
        (host: systemConf: systemConf //
          { inherit host; })
        (self.nixosConfigurations //
          self.darwinConfigurations);

      # Creates home-manager confgurations for each user on each host.
      # Tries to import users/${user} for each user.
      # Conditionally imports home/darwin and home/linux based on the host system.
      userConfigs = users:
        listToAttrs (concatMap
          ({ host, pkgs, ... }:
            let
              inherit (pkgs.stdenv) isDarwin isLinux;
            in
            map
              (user: {
                name = "${user}@${host}";
                value = homeManagerConfiguration {
                  inherit pkgs;
                  extraSpecialArgs = { inherit inputs; };
                  modules = [ ./home (importModule "users/${user}") ] ++
                    optionals isDarwin [ (importModule "home/darwin") ] ++
                    optionals isLinux [ (importModule "home/linux") ];
                };
              })
              users)
          allHosts);
    in
    {
      homeConfigurations = userConfigs [
        "ellie"
      ];
      nixosConfigurations = systemsWith nixosSystem ./nixos [
        {
          host = "dell-gram";
          system = "x86_64-linux";
        }
      ];
      darwinConfigurations = systemsWith darwinSystem ./darwin [
        {
          host = "EllMBP";
          system = "aarch64-darwin";
        }
      ];
    };
}
