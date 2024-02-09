{ config, osConfig, lib, ... }:
let
  replaceShellVars = builtins.replaceStrings
    [ "$HOME" "$USER" ]
    [ config.home.homeDirectory config.home.username ];

  systemPaths = builtins.filter builtins.isString (builtins.split ":" osConfig.environment.systemPath);
  envPaths = builtins.map replaceShellVars (systemPaths ++ config.home.sessionPath);
  escapedPath = builtins.toJSON envPaths;

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
