{ config, dfconf, extra, lib, pkgs, ... }:
{
  imports = [ ./xdg.nix ./zsh.nix ];

  config = extra.userDefinitions ({ config, ... }: {
    home = {
      shellAliases =
        let
          flakeRebuild = cmd: loc: "sudo nixos-rebuild ${cmd} --flake ${loc}#${dfconf.hostName}";
        in
        {
          osflake-dry = "${flakeRebuild "dry-activate" dfconf.dotfileRepo} --option tarball-ttl 0";
          osflake-switch = "${flakeRebuild "switch" dfconf.dotfileRepo} --option tarball-ttl 0";
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
