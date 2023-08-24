{ config, lib, pkgs, ... }:
let
  inherit (pkgs.nodePackages) prettier-plugin-toml;
  inherit (pkgs.stdenv) isLinux;
  inherit (lib) optionals attrValues;
  inherit (config.home) homeDirectory;
in
{
  xdg.configFile.nvim = {
    recursive = true;
    source = pkgs.substituteAllRec {
      src = ./nvim;
      nodejs = pkgs.nodejs;
      prettierToml = prettier-plugin-toml;
      repoDir = "${homeDirectory}/Code/dotfiles/home/neovim/nvim";
      inherit (pkgs) gcc;
      fontsize = if isLinux then 11 else 13;
    };
  };

  home = {
    packages = (attrValues {
      inherit (pkgs)
        neovim

        # Telescope
        ripgrep
        ripgrep-all


        # LuaJIT and luarocks
        luajit

        # LSPs
        sumneko-lua-language-server
        nil
        rust-analyzer
        ccls

        # Linters
        clippy
        shellcheck

        # Formatters
        stylua
        nixpkgs-fmt
        prisma-engines
        rustfmt
        beautysh;
      inherit (pkgs.nodePackages)
        prettier

        # LSPs from nodePackages
        bash-language-server
        yaml-language-server
        vscode-langservers-extracted
        prisma-language-server
        pyright
        tailwindcss-language-server
        volar
        typescript-language-server
        svelte-language-server
        eslint;

    }) ++ optionals isLinux (attrValues {
      inherit (pkgs)
        # Clipboard integration tools
        xclip
        wl-clipboard

        # Using the homebrew package on macOS
        neovide;
    });
  };
}
