{
  description = "Depends on the dotfile flake as an input";

  inputs = {
    dotfile-config.url = "github:ehllie/my-dotfiles/nix";
  };

  outputs = { dotfile-config, nixpkgs, ... }:
    let
      opts = {
        user = "ellie";
        host = "nixos-gram";
        boot-loader = "systemd-boot";
      };
    in
    {
      nixosConfigurations.${opts.host} = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # Include the results of the hardware scan.
          ./hardware.nix
        ] ++ dotfile-config.allModules opts;
      };
    };

}
