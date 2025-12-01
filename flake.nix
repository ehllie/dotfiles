{
  description = "An alright configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nil.url = "github:oxalica/nil";
    darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # For using new modules before the release of the next nixos version
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    ez-configs = {
      url = "github:ehllie/ez-configs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vanilla-plus = {
      url = "github:ehllie/vanilla-plus";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nix-minecraft.follows = "nix-minecraft";
        parts.follows = "flake-parts";
        ez-configs.follows = "ez-configs";
      };
    };
    nix-rosetta-builder = {
      url = "github:cpick/nix-rosetta-builder";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }:
      let
        inherit (lib) init last;
        inherit (inputs.nixvim.lib.nixvim) listToUnkeyedAttrs;
        extraLib.nixvim = {
          lazyMapping = mapping: listToUnkeyedAttrs (init mapping) // (last mapping);
        };
      in
      {
        imports = [
          inputs.ez-configs.flakeModule
        ];

        systems = [
          "aarch64-linux"
          "x86_64-linux"
          "aarch64-darwin"
          "x86_64-darwin"
        ];

        # see https://github.com/ehllie/ez-configs/blob/main/README.md
        ezConfigs = {
          root = ./.;
          globalArgs = { inherit inputs extraLib; };
          darwin.hosts.EllMBP.userHomeModules = [ "root" ];
          home.users.root.importDefault = false;
        };

        perSystem =
          {
            pkgs,
            lib,
            system,
            ...
          }:
          {

            _module.args.pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [
                inputs.sops-nix.overlays.default
                inputs.nixvim.overlays.default
              ];
            };

            formatter = pkgs.nixpkgs-fmt;

            packages = rec {
              foundryvtt = pkgs.callPackage ./packages/foundry-vtt { };
              nixvim = pkgs.nixvim.makeNixvimWithModule {
                module = ./neovim-modules;
                extraSpecialArgs = { inherit extraLib; };

              };
              default = nixvim;
            };

            devShells.default = pkgs.mkShell {
              name = "default-shell";
              packages = lib.attrValues {
                inherit (pkgs)
                  age
                  cloudflared
                  nixos-rebuild
                  sops
                  ssh-to-age
                  ;
              };
            };
          };
      }
    );
}
