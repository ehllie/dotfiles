# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware.nix
      # Include the package list.
      ./packages.nix
    ];

  # Use the systemd-boot EFI boot loader.
  # boot = {
  #   # Use the systemd-boot EFI boot loader
  #   loader.systemd-boot.enable = true;
  #   loader.efi.canTouchEfiVariables = true;
  #   # Kernel packages
  #   kernelPackages = pkgs.linuxPackages_zen;
  # };

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

  fonts.fonts = with pkgs; [
    # Nerd Fonts
    cascadia-code
    nerdfonts
  ];
  # Hardware
  # hardware = {
  #   cpu.intel.updateMicrocode = true;
  #   enableRedistributableFirmware = true;
  #   pulseaudio.enable = true;
  #   pulseaudio.package = pkgs.pulseaudioFull;
  #   bluetooth.enable = true;
  #   opengl.enable = true;
  #   opengl.driSupport = true;
  # };

  # Networking
  networking = {
    hostName = "nixos-gram";
    # wireless.iwd.enable = true;
    networkmanager = {
      enable = true;
      # wifi.backend = "iwd";
    };
    # firewall.enable = true;
    # firewall.allowPing = true;
    # firewall.allowedUDPPorts = [];
    # firewall.allowedTCPPorts = [];

    # hosts file
    # extraHosts = pkgs.stdenv.lib.readFile ( pkgs.fetchurl {
    #   url = "https://raw.githubusercontent.com/StevenBlack/hosts/5a5016ab5bf0166e004147cb49ccd0114ed29b72/alternates/fakenews-gambling-porn/hosts";
    #   sha256 = "1c60fyzxz89bic6ymcvb8fcanyxpzr8v2z5vixxr79d8mj0vjswm";
    # } );
  };

  # Timezone
  time.timeZone = "Europe/Warsaw";

  # Network Proxy
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
    # services.openssh.enable = true;

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
      # displayManager.defaultSession = "none+xmonad";
      desktopManager = {
        gnome.enable = true;
        # xmonad.enable = true;
        # xmonad.enableContribAndExtras = true;
        # xmonad.extraPackages = hpkgs: [
        #   hpkgs.xmonad
        #   hpkgs.xmonad-contrib
        #   hpkgs.xmonad-extras
        #   hpkgs.xmobar
        # ];
      };
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

    # pam.services.lightdm.enableGnomeKeyring = true;

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
