{ utils, dfconf }:
let cond = utils.enumDefinitions [ "windowManager" ] "xmonad"; in
utils.mkDefs {
  homeDefs = cond {
    programs.rofi = {
      enable = true;
      extraConfig = {
        kb-row-up = "Control+k";
        kb-row-down = "Control+j";
        kb-remove-to-eol = "";
        kb-accept-entry = "Control+l,Control+m,Return,KP_Enter";
        kb-mode-complete = "";
      };
    };
  };
}
