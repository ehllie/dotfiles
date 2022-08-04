{ pkgs, ... }:
let
  nvim-shell = pkgs.writeShellScriptBin "nvim" ''
    nix-shell $XDG_CONFIG_HOME/nvim/shell.nix
  '';
in
{
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

      #Graphical env
      neovide

      #Clipboard integration
      xclip
      wl-clipboard

      #Python and JS integration
      python310Packages.pynvim
      nodePackages.neovim

      #LuaJIT and luarocks
      luajit
      luajitPackages.luarocks

      #LSPs
      nodePackages.bash-language-server
      nodePackages.yaml-language-server
      nodePackages.vscode-langservers-extracted
      haskell-language-server
      sumneko-lua-language-server
      rnix-lsp

      #Linters
      mypy
      python310Packages.flake8

      #Formatters
      stylua
      nixpkgs-fmt
      black
      python310Packages.isort
      nodePackages.prettier
    ];
    sessionVariables = {
      NEOVIDE_MULTIGRID = true;
    };
  };
}
