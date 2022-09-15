{
  description = "An alright configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixos-wsl = { url = "github:nix-community/NixOS-WSL"; inputs.nixpkgs.follows = "nixpkgs"; };
    vscode-server = { url = "github:msteen/nixos-vscode-server"; inputs.nixpkgs.follows = "nixpkgs"; };
    beautysh = { url = "github:lovesegfault/beautysh"; inputs.nixpkgs.follows = "nixpkgs"; };
    volar.url = "github:ehllie/nixpkgs/volar";
    taffybar.url = "github:taffybar/taffybar";
  };

  outputs = { nixpkgs, home-manager, nixos-wsl, vscode-server, taffybar, volar, beautysh, ... }:
    let
      defaultConfig = {
        userName = "ellie";
        userDesc = "Elizabeth";
        dotfileRepo = "github:ehllie/dotfiles";
        shell = "zsh";
        colourscheme.catppuccin.enable = true;
      };

      system = "x86_64-linux";

      volarPkgs = volar.legacyPackages.${system};
      volarOverlay = self: super: {
        nodePackages = super.nodePackages // { inherit (volarPkgs.nodePackages) volar; };
      };

      beautyshOverlay = beautysh.overlay;

      inherit (nixpkgs) lib;

      flakeSystem = { dotfileConfig ? { }, extraModules ? [ ] }:
        let
          dotfiles = defaultConfig // dotfileConfig;
          globalConfigModule = {
            inherit dotfiles;
            home-manager = { useGlobalPkgs = true; useUserPackages = true; };
            nixpkgs.overlays = (import ./overlays) ++ taffybar.overlays ++ [ volarOverlay beautyshOverlay ];
          };
        in
        lib.nixosSystem {
          inherit system;
          specialArgs.myLib = ((import ./lib) { inherit nixpkgs; }).setDefaults dotfiles;
          modules = [
            ./.
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
            windowManager = "xmonad";
            samba = true;
            graphical = true;
          };
          extraModules = [ ./secrets ];
        };
        nixdesk = flakeSystem {
          dotfileConfig = {
            hostName = "nixdesk";
            hardware = "desktop";
            windowManager = "gnome";
            graphical = true;
          };
          extraModules = [ ./secrets ];
        };
        nixwsl = flakeSystem {
          dotfileConfig = {
            hostName = "nixwsl";
            colourscheme.catppuccin.enable = false;
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
                  docker-native.enable = false;
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
