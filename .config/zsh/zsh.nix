{ config, pkgs, lib, inputs, ... }:
{
  config.programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";

    initExtraFirst = builtins.readFile ./xdgrc;
    initExtra = builtins.concatStringsSep "\n" [
      (builtins.readFile ./.zshrc)
      (builtins.readFile ./pathrc)
      (builtins.readFile ./aliasrc)
    ];
  };
}
