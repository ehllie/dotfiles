{ lib, myLib, pkgs, config, ... }:
let
  userDefinitions = with pkgs; {
    services.taffybar.package = haskellPackages.callCabal2nix "my-taffybar" ./. { };
    systemd.user.services.status-notifier-item = {
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
      Install.WantedBy = [ "taffybar.service" ];
    };
  };
  hostDefinitions = {
    services = {
      xserver.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
      gnome.at-spi2-core.enable = true;
    };
  };
  enable = config.dotfiles.windowManager == "xmonad";
in
lib.mkIf enable (myLib.dualDefinitions {
  inherit hostDefinitions userDefinitions;
})
