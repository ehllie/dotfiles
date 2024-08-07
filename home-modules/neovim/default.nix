{ config, lib, pkgs, ... }:
let
  inherit (pkgs.nodePackages) prettier-plugin-toml;
  inherit (pkgs.stdenv) isLinux;
  inherit (lib) optionals attrValues;
  inherit (config.home) homeDirectory;

  codelldb_path = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
  codelldb = pkgs.runCommand "codelldb" { } ''
    mkdir -p $out/bin
    ln -s ${codelldb_path} $out/bin/codelldb
  '';
in
{
  xdg.configFile.nvim = {
    recursive = true;
    source = pkgs.substituteAllRec {
      src = ./nvim;
      nodejs = pkgs.nodejs;
      prettierToml = prettier-plugin-toml;
      repoDir = "${homeDirectory}/Code/dotfiles/home-modules/neovim/nvim";
      codelldb = codelldb_path;
      inherit (pkgs) gcc;
      fontsize = if isLinux then 11 else 13;
    };
    onChange = ''
      # Clear the LuaJIT cache
      rm -rf ${config.xdg.cacheHome}/.cache/nvim/luac/
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
        elixir-ls
        sqls
        tailwindcss-language-server
        clang-tools

        # Linters
        clippy
        shellcheck

        # Formatters
        stylua
        nixpkgs-fmt
        prisma-engines
        rustfmt
        beautysh
        ;
      inherit (pkgs.nodePackages)
        prettier

        # LSPs from nodePackages
        bash-language-server
        yaml-language-server
        vscode-langservers-extracted
        prisma-language-server
        pyright
        volar
        typescript-language-server
        svelte-language-server
        eslint;

    }) ++ [
      codelldb
    ] ++ optionals isLinux (attrValues {
      inherit (pkgs)
        # Clipboard integration tools
        xclip
        wl-clipboard

        # Using the homebrew package on macOS
        neovide;
    });
  };
}
