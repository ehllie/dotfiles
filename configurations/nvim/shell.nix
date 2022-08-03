{ pkgs ? import <nixpkgs> { } }:
(pkgs.buildFHSUserEnv { name = "neovim"; targetPkgs = pkgs: (with pkgs; [ neovim ]); runScript = "nvim"; }).env
