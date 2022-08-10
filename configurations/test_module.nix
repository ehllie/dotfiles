{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.test-module;
in
{
  options.test-module = {
    enabled = mkEnableOption "test-module";
  };
  config = mkIf cfg.enabled { home.packages = [ pkgs.alacritty ]; };
}
