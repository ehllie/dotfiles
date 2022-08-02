{ pkgs, home-manager, ... }:
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
      #Graphical env
      neovide

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
    ];
    sessionVariables = {
      NEOVIDE_MULTIGRID = true;
    };
  };
}
