{
  description = "An alright configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixos-wsl = { url = "github:nix-community/NixOS-WSL"; inputs.nixpkgs.follows = "nixpkgs"; };
    vscode-server = { url = "github:msteen/nixos-vscode-server"; inputs.nixpkgs.follows = "nixpkgs"; };
    taffybar.url = "github:taffybar/taffybar";
    nur.url = "github:nix-community/NUR";
    private.url = "/etc/nixos";
  };

  outputs = { nixpkgs, home-manager, nixos-wsl, vscode-server, taffybar, nur, private, ... }:
    let
      defaultConfig = {
        userName = "ellie";
        userDesc = "Elizabeth";
        dotfileRepo = "github:ehllie/dotfiles";
        shell = "zsh";
        colourscheme.catppuccin.enable = true;
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
            { nixpkgs.overlays = taffybar.overlays; }
          ] ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        nixgram = flakeSystem {
          dotfileConfig = {
            hostName = "nixgram";
            hardware = "dell-gram";
            windowManager = "xmonad";
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
            ({ myLib, lib, config, ... }: myLib.dualDefinitions {
              hostDefinitions = {
                systemd.services.fix-docker-desktop-distro = {
                  description = "Fixes permissions of docker-desktop-user-distro";
                  script = ''
                    chmod a+rx ${config.wsl.automountPath}/wsl/docker-desktop/docker-desktop-user-distro
                  '';
                  wantedBy = [ "docker-desktop-proxy.service" ];
                };
                wsl = {
                  enable = true;
                  automountPath = "/mnt";
                  defaultUser = defaultConfig.userName;
                  startMenuLaunchers = true;
                  docker-desktop.enable = true;
                  docker-native.enable = true;
                };
              };
              userDefinitions = {
                imports = [ vscode-server.nixosModules.home ];
                services.vscode-server.enable = true;
              };
            })
          ];
        };
      };
    };
}
