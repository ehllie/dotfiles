{ pkgs, home-manager, ... }:
{
  xdg.configFile = {
    "nvim/init.lua".source = ./init.lua;
    ".luarc.json".source = ./.luarc.json;
    "lua" = {
      recursive = true;
      source = ./lua;
    };
  };
  home = {
    packages = with pkgs; [
      stylua
      nixpkgs-fmt
      black
      python310Packages.isort
      python310Packages.pynvim
      nodePackages.prettier
      nodePackages.neovim
      luajit
      luajitPackages.luarocks
    ];
  };
}
