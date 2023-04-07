# Starter nix flake

I've made this starter config with by trimming down the one I have on the `main` branch.
This config is not really made with many machines and users in mind, unlike the original,
but I feel like that makes things clearer for new users of nix.

## Bootstrapping on MacOS

To get started using this config on MacOS, you will first need to get nix installed.
I have not personally used it, but [The Determinate Nix Installer](https://github.com/DeterminateSystems/nix-installer)
claims to fix some of the pain points I had with the [official installer](https://nixos.org/download.html#nix-install-macos) in the past.

After that, you will need to build the `darwinConfiguration` exposed in this flake,
in order to be able to run `darwinRebuild` and actually activate it.
On a fresh nix install, that will require, while inside this repository's directory, running:

```console
nix build --extra-experimental-features 'nix-command flakes' .#darwinConfigurations.your-hostname.system
./result/sw/bin/darwin-rebuild switch --flake .#your-hostname
```

On your next shell activation, you should have `darwinRebuild` available in the `PATH`.
Then, if you put `home-manager` on the list `systemPackages` in your config,
you should be able to activate your hm config with:

```console
home-manager switch --flake '.#your-username@your-hostname'
```

In case you don't have `home-manager` available, you can enter an ad-hoc shell with it with
`nix-shell -p home-manager`.
If `home-manager` complains about `nix command` and/or `nix flakes` include the flag
`--extra-experimental-features 'nix-command flakes'`.

After that, you should be done. You can rebuild your system wide config with `darwin-rebuild switch`
and your user config with `home-manager switch`, and manage your dotfiles in a version controlled repository.
