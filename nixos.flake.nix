{
  description = "Pure flake to put in /etc/nixos to be used as input by the dotfile flake";
  inputs = { };
  outputs = { ... }: {
    nixosModules.private = { ... }: {
      dotfiles.fido = {
        enable = true;
        credential = "FIDO2 credential";
      };
    };
  };
}
