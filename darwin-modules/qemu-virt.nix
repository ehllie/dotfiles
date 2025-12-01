{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;

  cfg = config.virtualisation.qemu;

  guestOptions.options = {
    guestConfiguration = lib.mkOption {
      type = types.attrs;
      description = "Configuration options for the QEMU guest.";
    };

    extraModules = lib.mkOption rec {
      type = types.listOf types.deferredModule;
      default = [
        (
          { modulesPath, ... }:
          {
            imports = [
              (modulesPath + "/profiles/qemu-guest.nix")
              (modulesPath + "/virtualisation/qemu-vm.nix")
            ];

            virtualisation = {
              qemu.guestAgent.enable = true;
              host.pkgs = pkgs;
              graphics = lib.mkDefault false;
            };
          }
        )
      ];

      apply = modules: modules ++ default;
      description = "Extra configuration options for the guest system.";
    };

    user = lib.mkOption {
      type = types.str;
      default = "root";
      description = "User to own the VM working directory.";
    };

  };

  mkDaemon =
    guest:
    {
      guestConfiguration,
      extraModules,
      user,
    }:
    let
      newConfig = guestConfiguration.extendModules {
        modules = extraModules;
      };
      hostname =
        if newConfig.config.networking ? hostName then newConfig.config.networking.hostName else guest;
    in
    {
      script = ''
        mkdir -p ${cfg.workdirPath}/${guest}

        ${newConfig.config.system.build.vm}/bin/run-${hostname}-vm

      '';

      serviceConfig = {
        KeepAlive = lib.mkDefault true;
        RunAtLoad = lib.mkDefault true;
        StandardErrorPath = "${cfg.ioLogPath}/${guest}/err.log";
        StandardOutPath = "${cfg.ioLogPath}/${guest}/out.log";
        WorkingDirectory = "${cfg.workdirPath}/${guest}";
        UserName = user;
      };
    };
in
{
  options.virtualisation.qemu = {
    enable = lib.mkEnableOption "Enable quemu guest virtualisation support";

    ioLogPath = lib.mkOption {
      type = types.path;
      default = "/var/log/qemu-vms";
      description = "Path to deamon stdOut and stdErr IO files directory.";
    };

    workdirPath = lib.mkOption {
      type = types.path;
      default = "/var/lib/qemu-vms";
      description = "Path to QEMU VM working directory.";
    };

    guests = lib.mkOption {
      default = { };
      type = types.attrsOf (types.submodule guestOptions);
    };
  };

  config = lib.mkIf cfg.enable {
    launchd.daemons = builtins.mapAttrs mkDaemon cfg.guests;

    system.activationScripts.preActivation.text = ''
      mkdir -p ${cfg.workdirPath}
      mkdir -p ${cfg.ioLogPath}
    ''
    + lib.concatStringsSep "\n" (
      map (
        guest:
        let
          workdir = "${cfg.workdirPath}/${guest}";
          logdir = "${cfg.ioLogPath}/${guest}";
        in
        ''
          mkdir -p ${workdir}
          mkdir -p ${logdir}
          chown -R ${cfg.guests.${guest}.user} ${workdir}
          chown -R ${cfg.guests.${guest}.user} ${logdir}
        ''
      ) (builtins.attrNames cfg.guests)
    );
  };
}
