{ config, lib, modulesPath, pkgs, ... }:
let
  inherit (lib) attrValues;
  systemPackages = attrValues {
    inherit (pkgs)
      bash
      coreutils
      fido2luks
      home-manager
      pulseaudio
      usbutils
      zsh;
  };
in

{
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_IE.UTF-8";
  console.keyMap = "pl";
  fileSystems."/" = { device = "/dev/vg1/root"; fsType = "ext4"; };
  swapDevices = [{ device = "/dev/vg1/swap"; }];
  virtualisation.docker.enable = true;
  systemd.services.upower.enable = true;
  hardware.bluetooth.enable = true;

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./xmonad.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "python3.10-poetry-1.2.2"
    ];
  };

  environment = {
    pathsToLink = [ "/share/zsh" ];
    inherit systemPackages;
  };

  nix = {
    extraOptions = "experimental-features = nix-command flakes";

    settings = {
      trusted-users = [ "@wheel" ];
      trusted-substituters = [ "https://nix-community.cachix.org" ];
      extra-substituters = [ "https://nix-community.cachix.org" ];
      extra-trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
    };

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
  };

  fonts.fonts = with pkgs; [
    cascadia-code
    (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
  ];

  networking = {
    networkmanager.enable = true;

    firewall = {
      allowPing = true;
      enable = true;
    };
  };

  services.timesyncd = {
    enable = true;
    servers = [ "pl.pool.ntp.org" ];
  };

  users.users.ellie = {
    isNormalUser = true;
    home = "/home/ellie";
    description = "Elizabeth";
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    initialPassword = "password"; # Change this asap obv
  };

  security = {
    rtkit.enable = true;

    sudo = {
      enable = true;
      wheelNeedsPassword = true;
      extraRules = [{
        groups = [ "wheel" ];
        commands = builtins.map
          (command: { inherit command; options = [ "NOPASSWD" ]; })
          [ "${pkgs.systemd}/bin/shutdown" "${pkgs.systemd}/bin/reboot" ];
      }];
    };
  };

  system = {
    stateVersion = "22.05";
    autoUpgrade.enable = true;
    autoUpgrade.allowReboot = true;
    autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable";
  };


  boot = {
    blacklistedKernelModules = [ "pcspkr" ];
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

    xserver = {
      gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
      desktopManager.xterm.enable = false;
      excludePackages = [ pkgs.xterm ];
      layout = "pl";

      libinput = {
        enable = true;
        touchpad.naturalScrolling = true;
      };
    };

    gnome = {
      gnome-keyring.enable = true;
      at-spi2-core.enable = true;
    };

    avahi = {
      enable = true;
      nssmdns = true;
    };

    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
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
      drivers = [ pkgs.brlaser ];
    };
  };

  programs = {
    dconf.enable = true;
    _1password.enable = true;

    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "ellie" ];
    };
  };

}
