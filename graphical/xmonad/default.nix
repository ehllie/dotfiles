{ myLib, config, pkgs, lib, ... }:
let
  cfg = config.dotfiles;

  hostDefinitions = {
    environment.systemPackages = [ pkgs.greetd.tuigreet ];
    services = {
      xserver = {
        enable = true;
        displayManager = {
          defaultSession = "none+xmonad";
          lightdm = {
            enable = true;
            greeters = {
              gtk.enable = false;
              enso.enable = true;
            };
          };
          # startx.enable = true;
        };
      };
      # greetd = with pkgs;{
      #   enable = true;
      #   settings = {
      #     default_session = {
      #       command = "${greetd.tuigreet}/bin/tuigreet --time -r --cmd startx";
      #       user = "greeter";
      #     };
      #   };
      # };
    };
  };
  userDefinitions = {
    programs.alacritty.enable = true;
    # home.file.".xinitrc".text = ''
    #   if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
    #   	eval $(dbus-launch --exit-with-session --sh-syntax)
    #   fi
    #   systemctl --user import-environment DISPLAY XAUTHORITY

    #   if command -v dbus-update-activation-environment >/dev/null 2>&1; then
    #           dbus-update-activation-environment DISPLAY XAUTHORITY
    #   fi
    # '';
    xsession = {
      enable = true;
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        config = pkgs.writeText "xmonad.hs" (builtins.readFile ./xmonad.hs);
      };
    };
  };
in
{
  options.dotfiles.windowManager = myLib.mkEnumOption "xmonad";

  config = lib.mkIf (cfg.windowManager == "xmonad")
    (myLib.dualDefinitions { inherit userDefinitions hostDefinitions; });
}
