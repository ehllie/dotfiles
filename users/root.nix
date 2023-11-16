{ ezModules, osConfig, ... }:
{
  imports = [
    ezModules.builder-ssh
  ];

  programs.ssh.enable = true;

  home = {
    username = "root";
    stateVersion = "23.05";
    homeDirectory = osConfig.users.users.root.home;
  };
}
