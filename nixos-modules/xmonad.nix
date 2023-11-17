{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.xcompmgr ];
  gtk.iconCache.enable = true;
  security.polkit.enable = true;

  services.xserver = {
    enable = true;
    windowManager.xmonad.enable = true;

    displayManager = {
      defaultSession = "none+xmonad";

      lightdm = {
        enable = true;

        greeters = {
          gtk.enable = false;
          enso.enable = true;
        };
      };
    };
  };
}
