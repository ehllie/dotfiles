{ utils, dfconf }:
let cond = utils.enumDefinitions [ "windowManager" ] "xmonad"; in
utils.mkDefs {
  homeDefs = { pkgs, ... }:
    let inherit (pkgs.haskellPackages) status-notifier-item callCabal2nix; in
    cond {
      services.taffybar = {
        enable = true;
        package = callCabal2nix "my-taffybar" ./. { };
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
          ExecStart = "${status-notifier-item}/bin/status-notifier-watcher";
          Restart = "on-failure";
        };
      };
    };

  nixosDefs = { pkgs, ... }: cond {
    services = {
      xserver.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
      gnome.at-spi2-core.enable = true;
    };
  };
}
