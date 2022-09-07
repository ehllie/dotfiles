{ myLib, config, pkgs, lib, ... }:
let
  cfg = config.dotfiles;

  hostDefinitions = {
    gtk.iconCache.enable = true;
    environment.systemPackages = [ pkgs.xcompmgr ];
    services = {
      xserver = {
        enable = true;
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
        windowManager.xmonad.enable = true;
      };
    };
    security.polkit.enable = true;


  };
  userDefinitions = {
    programs = {
      alacritty.enable = true;
      rofi.enable = true;
    };
    services.taffybar.enable = true;
    xsession = {
      enable = true;
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        config = pkgs.writeText "xmonad.hs" (builtins.readFile ./xmonad.hs);
        extraPackages = ps: with ps; [ taffybar ];
      };
    };
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      Unit = {
        Description = "Gnome polkit authentication agent";
        After = [ "graphical-session.target" ];

      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
in
{
  options.dotfiles.windowManager = myLib.mkEnumOption "xmonad";

  config = lib.mkIf (cfg.windowManager == "xmonad")
    (myLib.dualDefinitions { inherit userDefinitions hostDefinitions; });
}
