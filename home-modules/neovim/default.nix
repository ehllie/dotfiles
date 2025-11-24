{ inputs, extraLib, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimdiffAlias = true;
    imports = [
      {
        _module.args = { inherit inputs extraLib; };
        performance.byteCompileLua.enable = true;
      }
      ../../neovim-modules
    ];
  };
}
