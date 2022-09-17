{ config, dfconf, extra, lib, modulesPath, pkgs, ... }:
let
  samba = extra.boolDefinitions [ "samba" ] {
    services = {
      samba-wsdd.enable = true; # make shares visible for windows 10 clients

      samba = {
        enable = true;
        openFirewall = true;

        extraConfig = ''
          guest account = ${dfconf.userName}
          map to guest = Bad User

          follow symlinks = yes
          unix extensions = no
          wide links = yes

          load printers = no
          printcap name = /dev/null

          log file = /var/log/samba/client.%I
          log level = 2
        '';

        shares = {
          Code = {
            "path" = "/home/${dfconf.userName}/Code/samba";
            "guest ok" = "no";
            "read only" = "no";
          };
        };
      };
    };

    networking.firewall = {
      allowedTCPPorts = [ 5357 ]; # wsdd
      allowedUDPPorts = [ 3702 ]; # wsdd 
    };
  };
in
{
  imports = [
    ./dell-gram.nix
    ./desktop.nix
    samba
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  config = extra.enumDefinitions' [ "hardware" ] null {
    boot.blacklistedKernelModules = [ "pcspkr" ];
    fileSystems."/" = { device = "/dev/vg1/root"; fsType = "ext4"; };
    swapDevices = [{ device = "/dev/vg1/swap"; }];
    environment.systemPackages = [ pkgs.pulseaudio ]; # Enables pactl
    security.rtkit.enable = true;
    virtualisation.docker.enable = true;
    systemd.services.upower.enable = true;
    networking.networkmanager.enable = true;

    boot = {
      plymouth.enable = true;

      loader = {
        efi.canTouchEfiVariables = true;
        timeout = 0;

        systemd-boot = {
          enable = true;
          configurationLimit = 3;
        };
      };
    };

    services = {
      blueman.enable = true;
      thermald.enable = true;
      upower.enable = true;
      udisks2.enable = true;
      openssh.enable = true;

      dbus = {
        enable = true;
        packages = with pkgs;[ dconf ];
      };

      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        wireplumber.enable = true;
      };

      printing = {
        enable = true;
        drivers = with pkgs;[ brlaser ];
      };
    };
  };
}
