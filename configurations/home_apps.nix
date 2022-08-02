{ pkgs, ... }:
let
  # haskellPack = with pkgs.haskellPackages;
  #   let
  #     ps = p: with p;  [ async base containers lens mtl random stm text transformers unliftio ];
  #     ghc = ghcWithHoogle ps;
  #   in
  #   [
  #     ghc
  #     cabal-install
  #     hlint
  #     ghcide
  #     hnix
  #     stack
  #     haskell-language-server
  #   ];
  devPack = with pkgs; [
    gcc
    cargo
    nodePackages.pnpm
    python310
    pkgconfig
    nodejs
    go
  ];
  appPack = with pkgs; [
    libreoffice
    dmenu
  ];
  mediaPack = with pkgs; [
    firefox
    thunderbird
    vlc
  ];
  cliPack = with pkgs; [
    zsh
    git
    wget
    zip
    lazygit
    unzip
    htop
    coreutils
    killall
  ];
in
{
  home.packages = builtins.concatLists [
    # haskellPack
    devPack
    appPack
    mediaPack
    cliPack
  ];

}
