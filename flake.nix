{
  description = "An alright configuration";

  inputs = {
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    private.url = "/etc/nixos";
  };

  outputs = { nixpkgs, nur, home-manager, nixos-wsl, private, ... }:
    let
      defaultConfig = {
        userName = "ellie";
        userDesc = "Elizabeth";
        dotfileRepo = "github:ehllie/dotfiles";
        shell = "zsh";
      };

      inherit (nixpkgs) lib;

      flakeSystem = { dotfileConfig ? { }, extraModules ? [ ] }:
        let
          dotfiles = defaultConfig // dotfileConfig;
          globalConfigModule = {
            inherit dotfiles;
            home-manager = { useGlobalPkgs = true; useUserPackages = true; };
          };
        in
        lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs.myLib = ((import ./lib) { inherit nixpkgs; }).setDefaults dotfiles;
          modules = [
            ./.
            nur.nixosModules.nur
            home-manager.nixosModules.home-manager
            globalConfigModule
          ] ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        nixgram = flakeSystem {
          dotfileConfig = {
            hostName = "nixgram";
            hardware = "dell-gram";
            windowManager = "gnome";
            samba = true;
            graphical = true;
          };
          extraModules = [ private.nixosModules.private ];
        };
        nixdesk = flakeSystem {
          dotfileConfig = {
            hostName = "nixdesk";
            hardware = "desktop";
            windowManager = "gnome";
            graphical = true;
          };
          extraModules = [ private.nixosModules.private ];
        };
        nixwsl = flakeSystem {
          dotfileConfig = {
            hostName = "nixwsl";
          };
          extraModules = [
            nixos-wsl.nixosModules.wsl
            {
              wsl = {
                enable = true;
                automountPath = "/mnt";
                defaultUser = defaultConfig.userName;
                startMenuLaunchers = true;
                docker-desktop.enable = true;
                docker-native.enable = true;
              };
            }
          ];
        };
      };
    };
}
