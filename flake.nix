{
  description = "An alright configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixos-wsl = { url = "github:nix-community/NixOS-WSL"; inputs.nixpkgs.follows = "nixpkgs"; };
    vscode-server = { url = "github:msteen/nixos-vscode-server"; inputs.nixpkgs.follows = "nixpkgs"; };
    nil = { url = "github:oxalica/nil"; inputs.nixpkgs.follows = "nixpkgs"; };
    ante = { url = "github:jfecher/ante"; inputs.nixpkgs.follows = "nixpkgs"; };
    taffybar.url = "github:taffybar/taffybar";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
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

      utils = import ./utils.nix { inherit nixpkgs home-manager; };
      inherit (utils) flattenConfigs mkOutputs init;
      inherit (nixpkgs.lib) recursiveUpdate;

      flakeConfig = args@{ dfconf, homeExtra ? [ ], hostExtra ? [ ], ... }:
        let
          overlays = import ./overlays [
            taffybar.overlays
            nil.overlays.default
            ante.overlays.default
          ];
          prevConf = recursiveUpdate defaultConfig dfconf;
          utils = init { dfconf = prevConf; };
          secrets = utils.tryImport { src = ./secrets; };
          finalConf = recursiveUpdate prevConf (if secrets != false then secrets else { });
        in
        assert dfconf.hardware != null -> secrets != false;
        mkOutputs (args // {
          dfconf = finalConf;
          homeExtra = homeExtra ++ [
            overlays
          ];
          hostExtra = hostExtra ++ [
            overlays
            (if finalConf.hmMod
            then { home-manager = { useGlobalPkgs = true; useUserPackages = true; }; }
            else { })
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
    ];
}
