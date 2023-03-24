{ config, lib, pkgs, ... }:
let
  inherit (pkgs.nodePackages) prettier-plugin-svelte prettier-plugin-toml;
  inherit (pkgs.stdenv) isLinux;
  inherit (lib) optionals attrValues;
  inherit (config.home) homeDirectory;
in
{
  xdg.configFile.nvim = {
    recursive = true;
    source = pkgs.substituteAllRec {
      src = ./nvim;
      nodejs16 = pkgs.nodejs-16_x;
      prettierSvelte = prettier-plugin-svelte;
      prettierToml = prettier-plugin-toml;
      repoDir = "${homeDirectory}/Code/dotfiles/home/neovim/nvim";
      inherit (pkgs) gcc;
      fontsize = if isLinux then 11 else 13;
    };
    onChange = ''
      nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
    '';
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
        rustfmt
        beautysh;
      inherit (pkgs.nodePackages)
        prettier

        # LSPs from nodePackages
        bash-language-server
        yaml-language-server
        vscode-langservers-extracted
        pyright
        tailwindcss-language-server
        volar
        typescript-language-server
        svelte-language-server;

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
