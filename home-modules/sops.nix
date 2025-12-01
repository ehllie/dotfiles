{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  ssh-to-age = "${pkgs.ssh-to-age}/bin/ssh-to-age";
  op = "${pkgs._1password-cli}/bin/op";

  script = toString (
    pkgs.writeShellScript "op-age-keygen" ''
      set -euo pipefail
      ${op} read "op://Private/Sops/private key" 
        | ${ssh-to-age} -private-key
        > ${config.sops.keyFile}
    ''
  );
in
{

  imports = [ inputs.sops-nix.homeModules.sops ];

  sops.keyFile = "${config.xdg.configHome}/keys/age/keys.txt";

  launchd.agents.op-age = lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;
    config = {
      Program = script;
      KeepAlive = false;
      RunAtLoad = true;
    };
  };

  systemd.user.services.op-age = lib.mkIf pkgs.stdenv.isLinux {
    Unit = {
      Description = "Generate age key from 1Password ssh key";
    };
    Service = {
      Type = "oneshot";
      ExecStart = script;
    };
    Install.WantedBy = [ "sops-nix.service" ];

  };

}
