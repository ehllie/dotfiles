{ inputs, pkgs, ... }: {

  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  nix.settings.sandbox = "relaxed";
  nixpkgs.overlays = [
    inputs.vanilla-plus.overlays.default
    inputs.nix-minecraft.overlays.default
  ];

  services = {
    minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;
      servers.vanilla-plus = {
        enable = true;
        package = pkgs.fabricServers.fabric-1_21_8;
        jvmOpts = builtins.concatStringsSep " " [
          "-Xms12G"
          "-Xmx12G"
          "-XX:+UseG1GC"
          "-XX:+UnlockExperimentalVMOptions"
          "-XX:MaxGCPauseMillis=35"
          "-XX:+DisableExplicitGC"
          "-XX:TargetSurvivorRatio=90"
          "-XX:G1NewSizePercent=50"
          "-XX:G1MaxNewSizePercent=80"
          "-XX:G1MixedGCLiveThresholdPercent=50"
          "-XX:+AlwaysPreTouch"
        ];
        symlinks = {
          "mods" = "${pkgs.vanilla-plus-server}/mods";
        };
        serverProperties = {
          difficulty = "hard";
          white-list = true;
          motd = "1702 Roomies Server";
          view-distance = 20;
          simulation-distance = 14;
        };
        whitelist = {
          Ellie_eh = "fdfb210e-c03b-4e6a-bb9d-cb647786c4a5";
          # SaxyPandaBear = "773d108e-bbb4-4bef-b3dd-137413f62b97";
          # ponty10 = "d33471d8-1c4f-481b-87d6-b28ec77828c7";
          # UnlockedWifi42 = "a1504016-bb4c-4eda-9758-bed6c493891a";
          # Razentic12 = "35b16250-5264-4e9f-9e55-5dea17277b4f";
          # danipenguin = "d1fd607d-3bc9-49cd-83fd-469414ae3289";
          fadingroses = "8b9648b5-10de-45fd-b503-731919e701d9";
        };
      };
    };
  };
}
