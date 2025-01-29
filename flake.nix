{
  description = "An alright configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nil.url = "github:oxalica/nil";
    darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # For using new modules before the realease of the next nixos version
    home-manager-master = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ante = {
      url = "github:jfecher/ante";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        parts.follows = "flake-parts";
      };
    };
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
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake
    { inherit inputs; }
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
        globalArgs = { inherit inputs; };
        nixos.hosts.dell-builder.importDefault = false;
        darwin.hosts.EllMBP.userHomeModules = [ "root" ];
        home.users.root.importDefault = false;
      };

      perSystem = { pkgs, lib, system, ... }: {

        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [ inputs.sops-nix.overlays.default ];
        };

        formatter = pkgs.nixpkgs-fmt;

        packages.foundryvtt = pkgs.callPackage ./packages/foundry-vtt { };

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
    };
}
