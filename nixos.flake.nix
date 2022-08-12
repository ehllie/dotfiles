{
  description = "Depends on the dotfile flake as an input";

  inputs = {
    dotfiles.url = "github:ehllie/dotfiles/nix";
  };

  outputs = { dotfiles, nixpkgs, ... }:
    let
      opts = {
        user = "{{user}}";
        host = "{{host}}";
      };
    in
    {
      nixosConfigurations.${opts.host} = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # Include the results of the hardware scan.
          ./hardware.nix
        ] ++ dotfiles."{{preset}}" opts;
      };
    };

}
