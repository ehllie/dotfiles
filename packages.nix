# Package list

{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Basic CLI
    bash
    zsh
    git
    wget
    zip
    unzip
    coreutils
    killall
    usbutils
    ripgrep
    ripgrep-all

    # Haskell stuff
    # ghc
    # stack
    # cabal-install
    # hlint
    # haskell-language-server

    # Text stuff
    neovim

    # File managers
    ranger
    pcmanfm

    # Browsers
    firefox

    python310

  ];
}
