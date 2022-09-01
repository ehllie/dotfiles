{ myLib, ... }:
let
  userDefinitions = {
    xdg.configFile."taffybar/taffybar.hs".source = ./taffybar.hs;
  };
  hostDefinitions = {
    services = {
      xserver.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
      gnome.at-spi2-core.enable = true;
    };
  };
in
myLib.dualDefinitons { inherit hostDefinitions userDefinitions; }
