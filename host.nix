# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, hwConfig, ... }:

{
  imports =
    [
      # Include the package list.
      ./packages.nix
    ];

  # Bootloader.
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 3;
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    timeout = 0;
  };

  # Silence bios buzzer
  boot.blacklistedKernelModules = [ "pcspkr" ];

  environment.pathsToLink = [ "/share/zsh" ];

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  fonts.fonts = with pkgs;
    [
      # Nerd Fonts
      cascadia-code
      nerdfonts
    ];

  # Networking
  networking = {
    hostName = "nixos-gram";
    networkmanager = {
      enable = true;
    };
  };

  # Timezone
  time.timeZone = "Europe/Warsaw";

  # Locales
  i18n.defaultLocale = "en_IE.utf8";
  console = {
    # font = "Lat2-Terminus16";
    keyMap = "pl";
  };

  # Services
  services = {
    gnome.gnome-keyring.enable = true;
    upower.enable = true;

    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };

    # Time
    timesyncd = {
      enable = true;
      servers = [ "pl.pool.ntp.org" ];
    };

    # CUPS
    printing.enable = true;

    blueman.enable = true;

    thermald.enable = true;

    # OpenSSH daemon
    openssh.enable = true;

    iperf3.enable = true;

    # X config
    xserver = {
      enable = true;
      layout = "pl";
      libinput = {
        enable = true;
        touchpad = {
          naturalScrolling = true;
        };
      };
      videoDrivers = [ "modesetting" ];

      displayManager.gdm.enable = true;
      desktopManager = {
        gnome.enable = true;
      };
      # Begone xterm
      desktopManager.xterm.enable = false;
      excludePackages = [ pkgs.xterm ];
    };
  };

  systemd.services.upower.enable = true;

  # Sound
  sound.enable = true;

  # User accounts
  users.users = {
    ellie = {
      isNormalUser = true;
      home = "/home/ellie";
      shell = pkgs.zsh;
      description = "Elizabeth";
      extraGroups =
        [ "wheel" "networkmanager" "docker" ];
    };
  };

  # Sudo
  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = true;
    };

  };

  # Virtualization/other OS's support
  virtualisation.docker = {
    enable = true;
  };

  # Swap
  swapDevices = [
    { device = "/dev/disk/by-label/swap"; }
  ];

  # Other
  programs = {
    zsh.enable = true;
    # slock.enable = true;
  };

  system = {
    stateVersion = "22.05";
    autoUpgrade.enable = true;
    autoUpgrade.allowReboot = true;
    autoUpgrade.channel = https://nixos.org/channels/nixos-unstable;
  };

}
