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
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    ez-configs = {
      url = "github:ehllie/ez-configs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-darwin.follows = "nixpkgs-darwin";
        flake-parts.follows = "flake-parts";
        darwin.follows = "darwin";
        home-manager.follows = "home-manager";
      };

    };
  };

  outputs = inputs@{ flake-parts, ez-configs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ez-configs.flakeModule
      ];

      systems = [ ];

      ezConfigs = {
        root = ./.;
        globalArgs = { inherit inputs; };
        hm.users = [
          {
            name = "ellie";
          }
        ];

        darwin.hosts = [
          {
            name = "EllMBP";
            arch = "aarch64";
          }
        ];

        nixos.hosts = [
          {
            name = "dell-gram";
            arch = "x86_64";
          }
        ];
      };
    };
}
