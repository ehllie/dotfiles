{ pkgs, lib, myLib, ... }:
let
  parsers = with pkgs.tree-sitter; withPlugins (_: allGrammars);
in
myLib.userDefinitions {
  xdg.configFile = {
    "nvim/init.lua".text = ''
      require("nix-patches") 
    '' + (builtins.readFile ./init.lua);
    "nvim/.luarc.json".source = ./.luarc.json;
    "nvim/lua" = {
      recursive = true;
      source = ./lua;
    };
    "nvim/lua/nix-patches.lua".source =
      with pkgs; substituteAll { src = ./nix-patches.lua; inherit gcc parsers; };
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
      sumneko-lua-language-server
      rnix-lsp
      rust-analyzer

      #Linters
      clippy

      #Formatters
      stylua
      nixpkgs-fmt
      nodePackages.prettier
      rustfmt
    ];
    sessionVariables = {
      NEOVIDE_MULTIGRID = true;
    };
  };
}
