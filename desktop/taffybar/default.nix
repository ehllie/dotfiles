{ myLib, pkgs, ... }:
let
  userDefinitions = with pkgs; {
    services.taffybar.package = taffybar.override {
      packages = ps: with ps;[ data-default ];
    };
    systemd.user.services.taffybar.Service.RestartSec = 3;
    systemd.user.services.status-notifier-item = {
      Unit = {
        Description = "Status Notifier Item";
      };
      Service = {
        Type = "dbus";
        BusName = "org.kde.StatusNotifierWatcher";
        ExecStart = "${haskellPackages.status-notifier-item}/bin/status-notifier-watcher";
        Restart = "on-failure";
        RestartSec = 3;
      };
      Install.WantedBy = [ "taffybar.service" ];
    };
    xdg.configFile."taffybar/taffybar.hs".source = ./taffybar.hs;
  };
  hostDefinitions = {
    services = {
      xserver.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
      gnome.at-spi2-core.enable = true;
    };
  };
in
myLib.dualDefinitions { inherit hostDefinitions userDefinitions; }
