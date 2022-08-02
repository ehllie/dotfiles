{ pkgs ? import <nixpkgs>, ... }:
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

    (pkgs.buildFHSUserEnv {
    name = "nvim-env";
    targetPkgs = pkgs: (with pkgs;
      [
        neovim
        neovide

        nodejs
        python310
        cargo
        ripgrep

        #Python and JS integration
        python310Packages.pynvim
        nodePackages.neovim

        #LuaJIT and luarocks
        luajit
        luajitPackages.luarocks

        #Linters
        mypy
        python310Packages.flake8

        #Formatters
        stylua
        nixpkgs-fmt
        black
        python310Packages.isort
        nodePackages.prettier
      ];)
    runScript = "nvim";
  }).env;

  # packages = with pkgs;
  #   [
  #     #Graphical env
  #     neovide
  #
  #     #Python and JS integration
  #     python310Packages.pynvim
  #     nodePackages.neovim
  #
  #     #LuaJIT and luarocks
  #     luajit
  #     luajitPackages.luarocks
  #
  #     #LSPs
  #     nodePackages.bash-language-server
  #     nodePackages.vscode-langservers-extracted
  #     haskell-language-server
  #     sumneko-lua-language-server
  #
  #     #Linters
  #     mypy
  #     python310Packages.flake8
  #
  #     #Formatters
  #     stylua
  #     nixpkgs-fmt
  #     black
  #     python310Packages.isort
  #     nodePackages.prettier
  #   ];
  sessionVariables = {
    NEOVIDE_MULTIGRID = true;
  };
};
}
