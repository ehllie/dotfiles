{ pkgs, ... }:
let
  inherit (pkgs.haskellPackages)
    status-notifier-item
    callCabal2nix;
in
{
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
}
