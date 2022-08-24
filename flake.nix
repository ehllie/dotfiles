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
      dotfileRepo = "github:ehllie/dotfiles";
      user = "ellie";
      flakeSystem = { userName, hostName, machine, extraModules ? [ ] }:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nur.nixosModules.nur
            home-manager.nixosModules.home-manager
            ./hardware
            ./host
            {
              dot-opts = {
                hardware = { inherit machine; };
                host = { inherit userName hostName; };
              };
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${userName} = {
                  dot-opts = { inherit userName hostName dotfileRepo; };
                  imports = [ ./user ];
                };
              };
            }
          ] ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        nixgram = flakeSystem {
          userName = user;
          hostName = "nixgram";
          machine = "dell-gram";
          extraModules = [
            private.nixosModules.private
            {
              dot-opts.host = { samba = true; bareMetal = true; };
              home-manager.users.${user}.dot-opts.graphical = true;
            }
          ];
        };
        nixdesk = flakeSystem {
          userName = user;
          hostName = "nixdesk";
          machine = "desktop";
          extraModules = [
            private.nixosModules.private
            {
              dot-opts.host.bareMetal = true;
              home-manager.users.${user}.dot-opts.graphical = true;
            }
          ];
        };
        nixwsl = flakeSystem {
          userName = user;
          hostName = "nixwsl";
          machine = "none";
          extraModules = [
            nixos-wsl.nixosModules.wsl
            {
              wsl = {
                enable = true;
                automountPath = "/mnt";
                defaultUser = user;
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
