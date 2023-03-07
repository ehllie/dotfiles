{ utils, dfconf }: utils.mkDefs {
  imports = [
    ./colourscheme
    ./desktop
    ./hardware
    ./neovim
    ./shell
    ./terminal
  ];

  nixosDefs = { config, lib, pkgs, ... }:
    let
      systemPackages = with pkgs; [
        bash
        zsh
        coreutils
        usbutils
        fido2luks
        home-manager
      ];
    in

    {
      nixpkgs.config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "python3.10-poetry-1.2.2"
        ];
      };
      time.timeZone = "Europe/Warsaw";
      i18n.defaultLocale = "en_IE.UTF-8";
      console.keyMap = "pl";
      programs._1password.enable = true;

      environment = {
        pathsToLink = [ "/share/zsh" ];
        inherit systemPackages;
      };

      nix = {
        extraOptions = "experimental-features = nix-command flakes";

        settings = {
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
        hostName = dfconf.hostName;

        firewall = {
          allowPing = true;
          enable = true;
        };
      };

      services.timesyncd = {
        enable = true;
        servers = [ "pl.pool.ntp.org" ];
      };

      users.users.${dfconf.userName} = {
        isNormalUser = true;
        home = dfconf.homeDir;
        description = dfconf.userDesc;
        extraGroups = [ "wheel" "networkmanager" "docker" ];
        initialPassword = "password"; # Change this asap obv
      };

      security.sudo = {
        enable = true;
        wheelNeedsPassword = true;
        extraRules = [{
          groups = [ "wheel" ];
          commands = builtins.map
            (command: { inherit command; options = [ "NOPASSWD" ]; })
            [ "${pkgs.systemd}/bin/shutdown" "${pkgs.systemd}/bin/reboot" ];
        }];
      };

      system = {
        stateVersion = "22.05";
        autoUpgrade.enable = true;
        autoUpgrade.allowReboot = true;
        autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable";
      };
    };

}
