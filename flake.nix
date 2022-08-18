{
  description = "An alright configuration";

  inputs = {
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = inputs@{ self, nixpkgs, nur, home-manager, nixos-wsl, ... }:
    let
      modules = { host-modules ? [ ], user-modules ? [ ], opts }: [
        nur.nixosModules.nur
        home-manager.nixosModules.home-manager
        {
          imports = [ ./host/common.nix ] ++ host-modules;
          dot-opts = opts;

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${opts.user} = {
              imports = [ ./user/common.nix ] ++ user-modules;
              dot-opts = { inherit (opts) user host; };
            };
          };
        }
      ];
    in
    {
      allModules = opts: modules {
        host-modules = [ ./host/bare-metal.nix ];
        user-modules = [ ./user/graphical.nix ];
        opts = opts;
      };

      wslModules = opts: modules {
        host-modules = [
          nixos-wsl.nixosModules.wsl
          {
            wsl = {
              enable = true;
              automountPath = "/mnt";
              defaultUser = "${opts.user}";
              startMenuLaunchers = true;
              docker-desktop.enable = true;
              docker-native.enable = true;
            };
          }
        ];
        opts = opts;
      };

      nixosConfigurations =
        let
          local-config = import ./local.nix;
        in
        with local-config;
        {
          ${opts.host} = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = localModules ++ self.${preset} opts;
          };
        };
    };
}
