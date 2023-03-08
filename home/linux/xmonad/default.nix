{ pkgs, ... }: {
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
    Install.WantedBy = [ "graphical-session.target" ];

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
  };
}
