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
        samba = false;
        fontsize = 8;
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
          dfconf = lib.recursiveUpdate defaultConfig dotfileConfig;
          extra = (import ./lib) { inherit nixpkgs dfconf; };
          hm = home-manager.nixosModules.home-manager;
          overlays = import ./overlays [ taffybar.overlays volarOverlay beautyshOverlay ];
        in
        lib.nixosSystem {
          inherit system;
          specialArgs = { inherit extra dfconf; };
          modules = [ ./. hm overlays ] ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        nixgram = flakeSystem {
          dotfileConfig = ({
            hostName = "nixgram";
            hardware = "dell-gram";
            windowManager = "xmonad";
            samba = true;
            graphical = true;
          } // (import ./secrets));
        };
        nixdesk = flakeSystem {
          dotfileConfig = ({
            hostName = "nixdesk";
            hardware = "desktop";
            windowManager = "xmonad";
            fontsize = 11;
            graphical = true;
          } // (import ./secrets));
        };
        nixwsl = flakeSystem {
          dotfileConfig = {
            hostName = "nixwsl";
          };
          extraModules = [
            nixos-wsl.nixosModules.wsl
            ({ extra, lib, config, ... }: extra.dualDefinitions {
              hostDefinitions = {
                wsl = {
                  enable = true;
                  automountPath = "/mnt";
                  defaultUser = defaultConfig.userName;
                  startMenuLaunchers = true;
                  docker-desktop.enable = false;
                  docker-native.enable = false;
                };
              };
              userDefinitions = {
                imports = [ vscode-server.nixosModules.home ];
                services.vscode-server.enable = true;
                dconf.enable = false;
              };
            })
          ];
        };
      };
    };
}
