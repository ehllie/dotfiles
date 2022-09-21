{ config, dfconf, extra, lib, pkgs, ... }:
let
  show-pkg = pkgs.writeShellScriptBin "show-pkg" ''
    src="${dfconf.repoDir}"
    host="${dfconf.hostName}"

    nix eval --raw "$src#nixosConfigurations.$host.pkgs.$1.outPath"
  '';

  remote-op-pkg = pkgs.writeShellScriptBin "remote-op" ''
    dir=$(mktemp -dt tmp.dotfiles-XXXXXX)
    git clone ${dfconf.repoUrl} --depth 1 $dir
    cd $dir
    git-crypt unlock
    eval "$@"
    cd
    rm -rf $dir
  '';

in
{
  imports = [ ./xdg.nix ./zsh.nix ];

  config = extra.userDefinitions ({ config, ... }: {
    home = {
      shellAliases =
        let
          remote-op = "${remote-op-pkg}/bin/remote-op";
          flakeRebuild = cmd: loc: "sudo nixos-rebuild ${cmd} --flake ${loc}#${dfconf.hostName}";
        in
        {
          osflake-dry = "${remote-op} ${flakeRebuild "dry-activate" "."} --option tarball-ttl 0";
          osflake-switch = "${remote-op} ${flakeRebuild "switch" "."} --option tarball-ttl 0";
          locflake-dry = "${flakeRebuild "dry-activate" dfconf.repoDir}";
          locflake-switch = "${flakeRebuild "switch" dfconf.repoDir}";
          vim = "nvim";
        };
      packages = [ show-pkg ];
      sessionPath = [ "~/.local/bin" "${config.xdg.dataHome}/cargo/bin" ];
      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    };
  });
}
