{
  config,
  osConfig,
  pkgs,
  ...
}:
let
  inherit (osConfig.networking) hostName;
  inherit (pkgs.stdenv) isDarwin isLinux;
  inherit (config.home) username;

  homeSwitch = "home-manager switch --flake '.#${username}@${hostName}'";
  nixosSwitch = "nixos-rebuild switch --flake '.#${hostName}'";
  darwinSwitch = "darwin-rebuild switch --flake '.#${hostName}'";

in
{

  home = {
    packages = [ pkgs.powershell ];

    shellAliases = {
      inherit homeSwitch;

      vim = "nvim";
      direnv-init = ''echo "use flake" >> .envrc'';
      ".." = "cd ..";
      "..." = "cd ../..";
      top = "btm";
      btop = "btm";
      ls = "eza";
      cat = "bat -pp";
      tree = "erd --layout inverted --icons --human";
      # https://askubuntu.com/questions/22037/aliases-not-available-when-using-sudo
      # register sudo as alias to allow using other aliases with sudo
      sudo = "sudo ";
    }
    // (
      if isDarwin then
        { inherit darwinSwitch; }
      else if isLinux then
        { inherit nixosSwitch; }
      else
        { }
    );

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      SOPS_AGE_KEY_FILE = config.xdg.configHome + "/sops/keys/age/keys.txt";
    };
  };

  xdg.configFile."powershell/Microsoft.PowerShell_profile.ps1".text = ''
    Invoke-Expression (&starship init powershell)
    Set-PSReadlineOption -EditMode Vi -ViModeIndicator Cursor
  '';
}
