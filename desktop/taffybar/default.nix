{ config, dfconf, extra, lib, pkgs, ... }:
let
  userDefinitions = with pkgs; {
    services.taffybar = {
      enable = true;
      package = haskellPackages.callCabal2nix "my-taffybar" ./. { };
    };

    systemd.user.services.status-notifier-item = {
      Install.WantedBy = [ "taffybar.service" ];

      Unit = {
        Description = "Status Notifier Item";
        PartOf = [ "tray.target" ];
      };

      Service = {
        Type = "dbus";
        BusName = "org.kde.StatusNotifierWatcher";
        ExecStart = "${haskellPackages.status-notifier-item}/bin/status-notifier-watcher";
        Restart = "on-failure";
      };
    };
  };

  hostDefinitions = {
    services = {
      xserver.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
      gnome.at-spi2-core.enable = true;
    };
  };
in
extra.enumDefinitions [ "windowManager" ] "xmonad"
  (extra.dualDefinitions { inherit hostDefinitions userDefinitions; })
