{
  description = "An alright configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nur.url = github:nix-community/NUR;
    home-manager = { url = github:nix-community/home-manager; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = inputs@{ nur, home-manager, ... }:
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
              home = {
                username = opts.user;
                homeDirectory = "/home/${opts.user}";
              };
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

      wslModules = opts: modules { opts = opts; };
    };
}
