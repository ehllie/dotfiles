#!/usr/bin/env sh

HOST=$(hostname)
USER=$(whoami)

cat ./nixos.flake.nix | sudo tee /etc/nixos/flake.nix
sudo nixos-rebuild switch --flake /etc/nixos#$HOST

