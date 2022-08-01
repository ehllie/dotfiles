{
  description = "Depends on the dotfile flake as an input";

  inputs = {
    dotfile-config.url = "github:ehllie/my-dotfiles/nix";
  };

  outputs = { dotfile-config, ... }:
    {
      nixosConfigurations = dotfile-config.mkConfig { hwConfig = ./hardware.nix; };
    };

}
