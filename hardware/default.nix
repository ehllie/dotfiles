{ config, lib, pkgs, ... }: {
  imports = [
    ./desktop.nix
    ./dell-gram.nix
  ];
  options.dot-opts.hardware = with lib;
    {
      machine = mkOption {
        description = "The machine for which to setup hardware configuration for.";
        type = with types; nullOr (enum [ "none" ]);
      };
      fido = {
        enable = mkEnableOption "fido";
        credential = mkOption {
          type = types.str;
          default = "";
          description = "FIDO credential";
        };
      };
    };
}
