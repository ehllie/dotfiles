# Ellie's dotfiles

A nix flake with my machine configurations. It feels mostly done as I'm not spending nearly as much time maintaining it as I used to at the beginning.
Nowadays I mainly use nix on my darwin machine, but I kept the nixos configuration for my old laptop here as well.

## The configurations:

I use a couple fancy function to generate the attributes `nixosConfigurations`, `darwinConfigurations` and `homeConfigurations`.
Their explanation is in the comments inside the let bindings. Just usual nix user reinventing the wheel stuff.

Most of the work has gone into my neovim configuration as I spend most of the inside it.
I've tried doing my custom linux desktop _rice_, but I've found myself to not be that interested in it.
That's mainly the reason why I switched to macOS, I get to use my nix managed dotfiles for all things cli and don't have to concern myself with the desktop.

If you see me doing something stupid or hard to understand, feel free to open an issue.
I love taking inspiration and learning from other people's configurations, so I'd love to be able to offer the same.
There's a simpler version of a flake.nix on the [`starter-template` branch](https://github.com/ehllie/dotfiles/tree/starter-template)
