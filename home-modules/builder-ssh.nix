{ pkgs, ... }:
{
  programs.ssh = {
    settings."builder.ehllie.xyz" = {
      proxyCommand = "${pkgs.cloudflared}/bin/cloudflared access ssh --hostname %h";
    };
  };
}
