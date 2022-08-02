#!bash
cat ./nixos.flake.nix | sudo tee /etc/nixos/flake.nix
sudo nixos-rebuild switch --flake /etc/nixos#nixos-gram

