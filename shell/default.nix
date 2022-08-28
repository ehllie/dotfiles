{ config, lib, myLib, ... }:
let cfg = config.dotfiles; in
{
  imports = [ ./xdg.nix ./zsh.nix ];

  options.dotfiles = with lib; {
    shell = mkOption {
      description = "Which shell to use";
      type = with types; nullOr (enum [ ]);
    };
    dotfileRepo = mkOption {
      type = types.str;
      description = "Url of the dotfile repo";
    };
  };

  config = myLib.userDefinitions ({ config, ... }: {
    home = {
      shellAliases =
        let
          flakeRebuild = cmd: loc: "sudo nixos-rebuild ${cmd} --flake ${loc}#${cfg.hostName}";
        in
        {
          osflake-dry = "${flakeRebuild "dry-activate" cfg.dotfileRepo} --option tarball-ttl 0";
          osflake-switch = "${flakeRebuild "switch" cfg.dotfileRepo} --option tarball-ttl 0";
          locflake-dry = "${flakeRebuild "dry-activate" "."}";
          locflake-switch = "${flakeRebuild "switch" "."}";
          vim = "nvim";
        };
      sessionPath = [ "~/.local/bin" "${config.xdg.dataHome}/cargo/bin" ];
      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    };
  });
}
