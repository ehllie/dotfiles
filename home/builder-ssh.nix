{ pkgs, ... }:
{
  programs.ssh = {
    matchBlocks."builder.ehllie.xyz" = {
      proxyCommand = "${pkgs.cloudflared}/bin/cloudflared access ssh --hostname %h";
    };
  };
}
