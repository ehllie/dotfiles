#!/usr/bin/env sh

cat ./nixos.flake.nix | sudo tee /etc/nixos/flake.nix
sudo nixos-rebuild switch --flake /etc/nixos#$HOST

