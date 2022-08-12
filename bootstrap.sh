#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "Superuser permissions needed to edit the /etc/nixos file"
  sudo -E $0 $@
  exit 0
fi

wipe=0
host=$(hostname)
user=$(whoami)
preset="all"
valid_presets=("all" "wsl")


print_usage() {
  echo "This script will set up /etc/nixos to be a flake that depends on the github dotfiles as an input"
  echo "Usage: $0 [opts]"
  echo "opts:"
  echo "-w: Wipes the contents of /etc/nixos and creates a new hardware config"
  echo "-h {hostname}: Hostname to be used in the configuration"
  echo "-u {username}: Username to be used in the configuration"
  echo "-p [${valid_presets[0]}$(printf ' | %s' ${valid_presets[@]:1})]: Preset to be used in the configuration"
  exit 1
}

while getopts 'wu:h:p:' flag; do
  case $flag in
    w) wipe=1;;
    h) host=$OPTARG;;
    u) user=$OPTARG;;
    p) preset=$OPTARG;;
    *) print_usage;;
  esac
done

if echo ${valid_presets[@]} | grep -w $preset > /dev/null; then

  if [[ $wipe -eq 1 ]]; then
    nixos-generate-config
    mv /etc/nixos/hardware-configuration.nix /etc/nixos/hardware.nix
    rm /etc/nixos/configuration.nix
  elif [[ -f "/etc/nixos.bak/hardware-configuration.nix" ]]; then # Rename default hardware configuration file
    mv /etc/nixos/hardware-configuration.nix /etc/nixos/hardware.nix
  fi

  if [[ ! -f "/etc/nixos/hardware.nix" ]]; then
    echo "No existing hardware configuration found"
    print_usage
  else
    sed -e "s/{{host}}/${host}/g" \
    -e "s/{{user}}/${user}/g" \
    -e "s/{{preset}}/${preset}Modules/g" \
    ./nixos.flake.nix \
    > /etc/nixos/flake.nix

    if [[ -f "/etc/nixos/configuration.nix" ]]; then # Backup old configuration.nix
      mv /etc/nixos/configuration.nix /etc/nixos/configuration.nix.bak
    fi

  fi

else
  echo "$0: invalid preset ${preset}"
  print_usage
fi

