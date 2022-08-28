{ pkgs, lib, myLib, ... }:
myLib.userDefinitions {
  xdg.configFile = {
    "nvim/init.lua".source = ./init.lua;
    "nvim/.luarc.json".source = ./.luarc.json;
    "nvim/lua" = {
      recursive = true;
      source = ./lua;
    };
  };
  home = {
    packages = with pkgs; [
      neovim

      #Telescope
      ripgrep
      ripgrep-all

      #Graphical env
      neovide

      #Clipboard integration
      xclip
      wl-clipboard

      #Python and JS integration
      python3Packages.pynvim
      nodePackages.neovim

      #LuaJIT and luarocks
      luajit
      luajitPackages.luarocks

      #LSPs
      nodePackages.bash-language-server
      nodePackages.yaml-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages.pyright
      haskell-language-server
      sumneko-lua-language-server
      rnix-lsp
      rust-analyzer

      #Linters
      mypy
      python3Packages.flake8
      clippy

      #Formatters
      stylua
      nixpkgs-fmt
      black
      python3Packages.isort
      nodePackages.prettier
      rustfmt
    ];
    sessionVariables = {
      NEOVIDE_MULTIGRID = true;
    };
  };
}
