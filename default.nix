{ utils, dfconf }: utils.mkDefs {
  imports = [
    ./colourscheme
    ./desktop
    ./hardware
    ./neovim
    ./shell
    ./terminal
  ];

  nixosDefs = { config, lib, pkgs, ... }:
    let
      systemPackages = with pkgs; [
        bash
        zsh
        coreutils
        usbutils
        fido2luks
        home-manager
      ];
    in

    {
      nixpkgs.config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "python3.10-poetry-1.2.2"
        ];
      };
      time.timeZone = "Europe/Warsaw";
      i18n.defaultLocale = "en_IE.UTF-8";
      console.keyMap = "pl";
      programs._1password.enable = true;

      environment = {
        pathsToLink = [ "/share/zsh" ];
        inherit systemPackages;
      };

      nix = {
        extraOptions = "experimental-features = nix-command flakes";

        settings = {
          trusted-substituters = [ "https://nix-community.cachix.org" ];
          extra-substituters = [ "https://nix-community.cachix.org" ];
          extra-trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
        };

        gc = {
          automatic = true;
          dates = "daily";
          options = "--delete-older-than 7d";
        };
      };

      fonts.fonts = with pkgs; [
        cascadia-code
        (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
      ];

      networking = {
        hostName = dfconf.hostName;

        firewall = {
          allowPing = true;
          enable = true;
        };
      };

      services.timesyncd = {
        enable = true;
        servers = [ "pl.pool.ntp.org" ];
      };

      users.users.${dfconf.userName} = {
        isNormalUser = true;
        home = dfconf.homeDir;
        description = dfconf.userDesc;
        extraGroups = [ "wheel" "networkmanager" "docker" ];
        initialPassword = "password"; # Change this asap obv
      };

      security.sudo = {
        enable = true;
        wheelNeedsPassword = true;
        extraRules = [{
          groups = [ "wheel" ];
          commands = builtins.map
            (command: { inherit command; options = [ "NOPASSWD" ]; })
            [ "${pkgs.systemd}/bin/shutdown" "${pkgs.systemd}/bin/reboot" ];
        }];
      };

      system = {
        stateVersion = "22.05";
        autoUpgrade.enable = true;
        autoUpgrade.allowReboot = true;
        autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable";
      };
    };


  homeDefs = { config, pkgs, ... }:
    let
      graphical = utils.confVal [ "graphical" ] false;
      haskellPkgs = ps: with ps; [
        cabal-fmt
        fourmolu
        haskell-language-server
      ] ++ (if graphical then [
        xmonad
        xmonad-contrib
        xmonad-extras
        taffybar
      ] else [ ]);

      pythonPkgs = ps: with ps; [
        black
        flake8
        isort
        mypy
        pynvim
        debugpy
      ];

      packages = with pkgs; [
        (ghc.withPackages haskellPkgs)
        cabal-install

        (python3.withPackages pythonPkgs)
        poetry

        lldb
        cargo
        rustc
        gcc

        nodePackages.pnpm
        nodejs

        git
        git-crypt
        lazygit

        wget
        zip
        unzip

        btop
        killall
        glow
        tree
        pandoc
      ];
    in
    utils.trisectDarwin
      # Darwin only
      {
        # home.packages = with pkgs; [ ];
        programs.ssh. extraConfig = "IdentityAgent \"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
      }

      # Linux only
      {
        services.gpg-agent.enable = true;
        programs.ssh. extraConfig = "IdentityAgent ~/.1password/agent.sock";
      }
      # Unconditional
      {
        home = {
          username = dfconf.userName;
          homeDirectory = dfconf.homeDir;
          inherit packages;
          stateVersion = "22.05";
        };

        programs = {
          home-manager.enable = true;

          git = {
            enable = true;
            userName = "Elizabeth Paź";
            userEmail = "me@ehllie.xyz";
            extraConfig = {
              init.defaultBranch = "main";
              merge.conflictStyle = "diff3";
            };
            signing = {
              key = null;
              signByDefault = true;
            };
          };

          gpg = {
            enable = true;
            homedir = "${config.xdg.dataHome}/gnupg";
          };
          # Host *
          #   IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

          ssh = {
            enable = true;
          };
        };

        xdg.configFile = {
          "mypy/config".text = ''
            [mypy]
            python_version = 3.10
            strict = True
            no_implicit_optional = False
          '';
          "lazygit/config.yml".text = ''
            git:
              autoFetch: false
          '';
          "cabal/config".text = ''
            repository hackage.haskell.org
              url: http://hackage.haskell.org/

            remote-repo-cache: ${config.xdg.cacheHome}/cabal/packages
            extra-prog-path: ${config.xdg.dataHome}/cabal/bin
            build-summary: ${config.xdg.dataHome}/cabal/logs/build.log
            remote-build-reporting: none
            jobs: $ncpus
            installdir: ${config.xdg.dataHome}/cabal/bin
          '';
        };
      };

  darwinDefs = { pkgs, ... }: {

    programs.zsh.enable = true;
    security.pam.enableSudoTouchIdAuth = true;
    nixpkgs.config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "python3.10-poetry-1.2.2"
      ];
    };

    homebrew = {
      enable = true;
      casks = [
        "neovide"
        "1password"
        "discord"
        "microsoft-office"
        "protonmail-bridge"
        "protonvpn"
        "firefox"
        "steam"
        "pritunl"
        "adobe-acrobat-pro"
        "mos"
        "xiv-on-mac"
        "aldente"
        "teamviewer"
        "calibre"
        "prismlauncher"
        "maccy"
        "transmission"
        "vlc"
      ];
      onActivation.cleanup = "zap";

    };

    fonts = {
      fontDir.enable = true;
      fonts = with pkgs; [
        cascadia-code
        (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
      ];
    };

    environment = {
      pathsToLink = [ "/share/zsh" ];
      systemPackages = with pkgs; [ zsh coreutils ];
    };
    nix = {
      extraOptions = "experimental-features = nix-command flakes";

      settings = {
        # sandbox = true;
        trusted-substituters = [ "https://nix-community.cachix.org" ];
        extra-substituters = [ "https://nix-community.cachix.org" ];
        extra-trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
      };

      gc = {
        automatic = true;
        options = "--delete-older-than 7d";
      };
    };
    services.nix-daemon.enable = true;
    users.users.${dfconf.userName} = {
      home = dfconf.homeDir;
      description = dfconf.userDesc;
    };
  };
}
