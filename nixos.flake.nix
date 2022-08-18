{
  description = "Pulls in dotfiles and passes local-config to them";
  inputs = { dotfiles.url = "github:ehllie/dotfiles"; };
  outputs = { dotfiles, ... }: { nixosConfigurations = dotfiles.mkConfiguration (import ./local.nix); };
}
