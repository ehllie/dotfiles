{ utils, dfconf }:
let cond = utils.enumDefinitions [ "windowManager" ] "gnome"; in
utils.mkDefs {
  hostDefs = cond {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };

  homeDefs = { pkgs, ... }: cond {
    home.packages = with pkgs; [
      gtk-engine-murrine
      dconf
      gnome.dconf-editor
      gnome.gnome-tweaks
      gnome.gnome-themes-extra
    ];
  };
}
