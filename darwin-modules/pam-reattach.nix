{ pkgs, lib, config, ... }:
let

  cfg = config.security.pam;
  # Copied from "security.pam.enableSudoTouchIdAuth"
  mkSudoPamReattachScript = isEnabled:
    let
      modulePath = "/opt/homebrew/lib/pam/pam_reattach.so";
      file = "/etc/pam.d/sudo";
      option = "security.pam.enablePamReattach";
      sed = "${pkgs.gnused}/bin/sed";
    in
    ''
      ${if isEnabled then ''
        if ! grep '${modulePath}' ${file} > /dev/null; then
          ${sed} -i '2i\
        auth       optional       ${modulePath} # nix-darwin: ${option} 
          ' ${file}
        fi
      '' else ''
        if grep '${option}' ${file} > /dev/null; then
          ${sed} -i '/${option}/d' ${file}
        fi
      ''}
    '';
in
{

  options.security.pam.enablePamReattach = lib.mkEnableOption "Include pam-reattach in sudo PAM configuration";

  config = {
    homebrew = lib.mkIf cfg.enablePamReattach {
      enable = true;
      brews = [
        "pam-reattach"
      ];
    };

    system.activationScripts.pam.text = ''
      # pam-reattach settings
      echo >&2 "setting up pam-reattach..."
      ${mkSudoPamReattachScript cfg.enablePamReattach}
    '';
  };
}
