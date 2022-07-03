#!/bin/bash

if [ "$(id -u)" == "0" ]; then
    echo "This script should not be run as root"
    exit 1
fi

git clone "--separate-git-dir=${XDG_CONFIG_HOME:-$HOME/.config}/dotfile-gitdir" "https://github.com/ehllie/my-dotfiles.git" "${XDG_CACHE_HOME:-$HOME/.cache}/dotfile-gitdir"
rm -r "${XDG_CACHE_HOME:-$HOME/.cache}/dotfile-gitdir"
git --git-dir=${XDG_CONFIG_HOME:-$HOME/.config}/dotfile-gitdir --work-tree=$HOME update-index --assume-unchanged $HOME/{README.md,bootstrap.sh}
git --git-dir=${XDG_CONFIG_HOME:-$HOME/.config}/dotfile-gitdir --work-tree=$HOME config status.showUntrackedFiles no
git --git-dir=${XDG_CONFIG_HOME:-$HOME/.config}/dotfile-gitdir --work-tree=$HOME status
git --git-dir=${XDG_CONFIG_HOME:-$HOME/.config}/dotfile-gitdir --work-tree=$HOME reset --hard origin/main
