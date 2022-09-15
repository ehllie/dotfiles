# Ellie's dotfiles

A nix flake with my machine configurations. Constantly changing, and I'm probably spending way too much time on it.
This is made with NixOs in mind, but there's plenty things that should apply to any distribution.

## The configurations:

This flake provides 3 configurations for each of the machines I use it on.

- My desktop with `nixosConfigurations.nixdesk`
- My laptop with `nixosConfigurations.nixgram`
- My wsl installation running on my work pc with `nixosConfigurations.nixwsl`

Most of the work has gone into my neovim configuration as I spend most of the time on my machines inside it.
I have taken steps towards a custom graphical environment with xmonad, but at the moment I'd call it quite bare bone.
If I ever get it to the point of being _pretty,_ I'll make sure to make one of those long readme pages with pictures and all.

If you see me doing something stupid or hard to understand, feel free to open an issue.
I love taking inspiration and learning from other people's configurations, so I'd love to be able to offer the same.
