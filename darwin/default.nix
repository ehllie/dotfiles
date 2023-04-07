# This is a nix module file. Modules are constant attrsets, or functions that return attrsets.
# For more info on moduels: https://nixos.wiki/wiki/NixOS_modules
# For this module in particular, we're using the configuration defined in nix-darwin.
# All nix-darwin options can be found here: https://daiderd.com/nix-darwin/manual/index.html#sec-options
# It's a parallel to the nixos options, but for macOS. This is system wide configuration,
# as opposed to user configuration, which is managed by home-manager.
{ pkgs, lib, ... }:
# Putting the `attrValues` function into the scope.
# You can search for functions in the nixpkgs standard library here: https://noogle.dev
let inherit (lib) attrValues; in
{

  programs.zsh.enable = true; # Manage zsh install with nix
  security.pam.enableSudoTouchIdAuth = true; # Allow for sudo authentication with TouchID

  # Manage which hombrew packages are installed here.
  homebrew = {
    enable = true;
    casks = [ ];
    # This will uninstall all packages that are not in the list here
    # each time you run `darwin-rebuild switch`.
    onActivation.cleanup = "zap";
  };

  # Install fonts from nixpkgs, as well as nerd fonts.
  fonts = {
    fontDir.enable = true;
    fonts = [
      pkgs.cascadia-code
      # You probably want to override the fonts to only include the font you use,
      # Otherwise rebuilds will be long as nix will download all the fonts that nerdfonts are configured with.
      # For a list of available fonts, see: https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/fonts/nerdfonts/shas.nix
      (pkgs.nerdfonts.override { fonts = [ "CascadiaCode" ]; })
    ];
  };

  environment = {
    pathsToLink = [ "/share/zsh" ];
    # These are the packages you want availabe to globally on the system.
    # Using the `attrValues` function instead of a more common `with pkgs; [ ... ]`
    # because it gives clearer error messages when something is missing.
    # For more anti patterns, see: https://nix.dev/anti-patterns/language#with-attrset-expression
    systemPackages = attrValues {
      inherit (pkgs) zsh coreutils home-manager;
    };
  };

  nix = {
    # Required for flakes
    extraOptions = "experimental-features = nix-command flakes";

    # This sets up garbage collector to run at 3:15 on Saturday.
    # It will delete all paths from the store that don't have a path to them from GC root.
    # Garbage collection is explained here: https://nixos.org/guides/nix-pills/garbage-collector.html
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
      interval = { Hour = 3; Minute = 15; Weekday = 6; };
    };
  };
  # Nix daemon is required for building things without root privilages
  services.nix-daemon.enable = true;
}
