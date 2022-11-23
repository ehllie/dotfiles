{
  description = "An alright configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    darwin = { url = "github:lnl7/nix-darwin/master"; inputs.nixpkgs.follows = "nixpkgs-darwin"; };
    nixos-wsl = { url = "github:nix-community/NixOS-WSL"; inputs.nixpkgs.follows = "nixpkgs"; };
    vscode-server = { url = "github:msteen/nixos-vscode-server"; inputs.nixpkgs.follows = "nixpkgs"; };
    nil = { url = "github:oxalica/nil"; inputs.nixpkgs.follows = "nixpkgs"; };
    ante = { url = "github:jfecher/ante"; inputs.nixpkgs.follows = "nixpkgs"; };
    taffybar.url = "github:taffybar/taffybar";
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-darwin
    , home-manager
    , darwin
    , nixos-wsl
    , vscode-server
    , taffybar
    , nil
    , ante
    }:
    let
      defaultConfig = rec {
        userName = "ellie";
        userDesc = "Elizabeth";
        hardware = null;
        dotfileRepo = "github:ehllie/dotfiles";
        repoUrl = "https://github.com/ehllie/dotfiles.git";
        homeDir = "/home/" + userName;
        repoDir = homeDir + "/Code/dotfiles";
        shell = "zsh";
        samba = false;
        fontsize = 8;
        colourscheme.catppuccin.enable = true;
        hmMod = true;
      };

      utils = import ./utils.nix { inherit nixpkgs nixpkgs-darwin home-manager darwin; };
      inherit (utils) flattenConfigs mkOutputs;
      inherit (nixpkgs.lib) recursiveUpdate;

      flakeConfig = args@{ dfconf, homeExtra ? [ ], nixosExtra ? [ ], darwinExtra ? [ ], ... }:
        let
          overlays = import ./overlays [
            taffybar.overlays
            nil.overlays.default
            ante.overlays.default
          ];
          finalConf = recursiveUpdate defaultConfig dfconf;
          hmExtra =
            if finalConf.hmMod
            then { home-manager = { useGlobalPkgs = true; useUserPackages = true; }; }
            else { };
        in
        mkOutputs (args // {
          dfconf = finalConf;
          homeExtra = homeExtra ++ [
            overlays
          ];
          nixosExtra = nixosExtra ++ [
            overlays
            hmExtra
          ];
          darwinExtra = darwinExtra ++ [
            overlays
            hmExtra
          ];
          root = ./.;
        });
    in
    flattenConfigs [
      (flakeConfig {
        dfconf = {
          system = "x86_64-linux";
          hostName = "nixgram";
          hardware = "dell-gram";
          windowManager = "xmonad";
          samba = true;
          graphical = true;
        };
      })
      (flakeConfig {
        dfconf = {
          system = "x86_64-linux";
          hostName = "nixdesk";
          hardware = "desktop";
          windowManager = "xmonad";
          fontsize = 11;
          graphical = true;
        };
      })
      (flakeConfig {
        dfconf = rec {
          system = "aarch64-darwin";
          hostName = "nixm1";
          homeDir = "/Users/ellie";
          repoDir = homeDir + "/Code/dotfiles";
          graphical = false;
          fontsize = 13;
        };
      })
    ];
}
