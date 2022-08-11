{
  description = "An alright configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nur.url = github:nix-community/NUR;
    home-manager = { url = github:nix-community/home-manager; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = inputs@{ nur, home-manager, ... }:
    {

      modules = opts: [
        nur.nixosModules.nur
        home-manager.nixosModules.home-manager
        {
          imports = [ ./host.nix ./packages.nix ];
          dotfile-presets = opts;

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${opts.user} = {
              imports = [ ./home-manager/home.nix ];
              home = {

                username = opts.user;
                homeDirectory = "/home/${opts.user}";
              };
            };
          };
        }
      ];

    };
}
