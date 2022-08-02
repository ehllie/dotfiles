{ pkgs ? import <nixpkgs> { } }:
(pkgs.buildFHSUserEnv { name = "neovim"; runScript = "nvim"; }).env
