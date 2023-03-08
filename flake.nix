{
  description = "An alright configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    darwin = { url = "github:lnl7/nix-darwin/master"; inputs.nixpkgs.follows = "nixpkgs-darwin"; };
    nil.url = "github:oxalica/nil";
    ante = { url = "github:jfecher/ante"; inputs.nixpkgs.follows = "nixpkgs"; };
    docs-gen.url = "git+ssh://git@github.com/SayInvest/docs-gen?branch=release-0.1.git";
    neovim = { url = "github:nix-community/neovim-nightly-overlay"; inputs.nixpkgs.follows = "nixpkgs"; };
    doom.url = "github:nix-community/nix-doom-emacs";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , darwin
    , ...
    }@inputs:
    let
      inherit (builtins) listToAttrs;
      inherit (nixpkgs.lib) concatMap mapAttrsToList nixosSystem optionals;
      inherit (darwin.lib) darwinSystem;
      inherit (home-manager.lib) homeManagerConfiguration;

      allHosts = mapAttrsToList
        (host: cfg: {
          inherit host cfg;
        })
        (self.nixosConfigurations //
          self.darwinConfigurations);

      hostUserConfigs = { mkHMConf, host, cfg }:
        mapAttrsToList
          (user: value: {
            name = "${user}@${host}";
            inherit value;
          })
          (mkHMConf cfg.pkgs);

      enumerateHosts = mkHMConf:
        listToAttrs (concatMap
          (hostInfo:
            hostUserConfigs
              (hostInfo // { inherit mkHMConf; }))
          allHosts);
    in
    {
      homeConfigurations = enumerateHosts (pkgs:
        let inherit (pkgs.stdenv) isDarwin isLinux; in
        {
          ellie = homeManagerConfiguration {
            inherit pkgs;
            modules = [ ./home ./users/ellie.nix ] ++
              optionals isDarwin [ ./home/darwin.nix ] ++
              optionals isLinux [ ./home/linux ];
            extraSpecialArgs = { inherit inputs; };
          };
        });
      nixosConfigurations = {
        dell-gram = nixosSystem {
          system = "x86_64-linux";
          modules = [ ./nixos ./hosts/dell-gram.nix ];
          specialArgs = { inherit inputs; };
        };
      };
      darwinConfigurations = {
        EllMBP = darwinSystem {
          system = "aarch64-darwin";
          modules = [ ./darwin ./overlays ];
          specialArgs = { inherit inputs; };
        };
      };
    };
}
