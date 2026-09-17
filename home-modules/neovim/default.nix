{ inputs, extraLib, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];
  programs.nixvim = {
    _module.args = { inherit inputs extraLib; };
    enable = true;
    defaultEditor = true;
    vimdiffAlias = true;
    performance.byteCompileLua.enable = true;
    imports = [
      ../../neovim-modules
    ];
  };
}
