{ config, osConfig, lib, ... }:
let
  envPaths = lib.concatStringsSep ":"
    (builtins.filter
      (s: s != "")
      ([ osConfig.environment.systemPath ] ++ config.home.sessionPath));
  escapedPath = builtins.replaceStrings
    [ "$HOME" "$USER" ]
    [ config.home.homeDirectory config.home.username ]
    envPaths;

  sessionVariables = builtins.mapAttrs
    (_: builtins.toString)
    config.home.sessionVariables;

  skipAliases = [
    "ls" # nushell has a better version of ls built in
  ];
  aliases = lib.filterAttrs
    (name: _: ! (builtins.elem name skipAliases))
    config.home.shellAliases;
in
{
  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    loginFile.source = ./login.nu;

    environmentVariables = sessionVariables // {
      PATH = escapedPath;
    };

    extraConfig = lib.concatStringsSep "\n" (
      lib.mapAttrsToList
        (name: value: "alias ${name} = ${value}")
        aliases
    );
  };
}
