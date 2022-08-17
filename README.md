# My Dotfiles
Not the most sophisticated stuff, but it's mine.
Nix flake to keep my changes synced across devices and easy to move to a new install.
Really new to nix, don't copy this if you don't absolutely have to.


### To sync with the repository:
* Clone the repository
* Create a flake.nix file in `/etc/nixos` based on `nixos.flake.nix`
* Run `nixos-rebuild switch --flake github:ehllie/dotfiles#$HOSTNAME`
