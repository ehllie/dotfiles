{
  description = "An alright configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    darwin = { url = "github:lnl7/nix-darwin/master"; inputs.nixpkgs.follows = "nixpkgs-darwin"; };
    nixos-wsl = { url = "github:nix-community/NixOS-WSL"; inputs.nixpkgs.follows = "nixpkgs"; };
    vscode-server = { url = "github:msteen/nixos-vscode-server"; inputs.nixpkgs.follows = "nixpkgs"; };
    nil = { url = "github:oxalica/nil"; };
    ante = { url = "github:jfecher/ante"; inputs.nixpkgs.follows = "nixpkgs"; };
    taffybar.url = "github:taffybar/taffybar";
    docs-gen = { url = "git+ssh://git@github.com/ehllie/docs-gen.git"; inputs.nixpkgs.follows = "nixpkgs"; };
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
    , docs-gen
    }:
    let
      inherit (nixpkgs.lib) genAttrs;
      inherit (builtins) attrNames;
      enumerateHosts = genAttrs (attrNames self.nixosConfigurations ++ attrNames self.darwinConfigurations);
    in
    {
      homeConfigurations = enumerateHosts (host: {
        "ellie@${host}" = { };
      });
      nixosConfigurations = { };
      darwinConfigurations = { };
    };
}
