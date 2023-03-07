{ ... }: {
  services.gpg-agent.enable = true;
  programs.ssh.extraConfig = ''
    IdentityAgent ~/.1password/agent.sock
  '';
}
