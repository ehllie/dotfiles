{ nixpkgs, nixpkgs-darwin, home-manager, darwin }:
let
  inherit (nixpkgs.lib)
    attrByPath mkIf mkOption types nixosSystem recursiveUpdate;
  inherit (home-manager.lib) homeManagerConfiguration;
  inherit (darwin.lib) darwinSystem;
  inherit (builtins) isBool isFunction isAttrs isPath foldl' functionArgs all elem attrNames;
  utils = rec {
    init = { dfconf }:
      let
        inherit (dfconf) system;
        pkgs = import nixpkgs { inherit system; };
        inherit (pkgs) stdenvNoCC haskellPackages;
        full = utils // rec {

          mkDefs = { imports ? [ ], homeDefs ? { }, nixosDefs ? { }, darwinDefs ? { } }:
            let
              importFunc = i:
                let
                  dotfileFunc = all
                    (x: elem x [ "utils" "dfconf" ])
                    (attrNames (functionArgs i));
                in
                assert isAttrs i || isPath i || isFunction i;
                if isPath i then importFunc (import i)
                else if isAttrs i then i
                else if dotfileFunc then i { utils = full; inherit dfconf; }
                else i;

              imported = map importFunc imports;
              merge = { homeI, nixosI, darwinI }: { homeDefs, nixosDefs, darwinDefs }:
                {
                  homeI = homeI ++ homeDefs;
                  nixosI = nixosI ++ nixosDefs;
                  darwinI = darwinI ++ darwinDefs;
                };

              imports' = foldl' merge { homeI = [ ]; nixosI = [ ]; darwinI = [ ]; } imported;
            in
            {
              homeDefs = [ homeDefs ] ++ imports'.homeI;
              nixosDefs = [ nixosDefs ] ++ imports'.nixosI;
              darwinDefs = [ darwinDefs ] ++ imports'.darwinI;
            };

          condDefinitions = path: default: pred: definitions:
            let
              val = attrByPath path default dfconf;
              enable = pred val;
            in
            mkIf enable definitions;

          boolDefinitions = path: condDefinitions path false (v: assert isBool v; v);
          boolDefinitions' = path: condDefinitions path false (v: assert isBool v; !v);

          enumDefinitions = path: val: condDefinitions path null (v: v == val);
          enumDefinitions' = path: val: condDefinitions path null (v: v != val);

          mkEnumOption = enumVal: mkOption { type = with types; nullOr (enum [ enumVal ]); };

          tryExtend = args: recursiveUpdate dfconf (tryImport args);

          tryImport = args@{ src, default ? "false", ... }:
            let
              valid = stdenvNoCC.mkDerivation {
                name = if args ? name then args.name else baseNameOf (toString args.src);
                nativeBuildInputs = [ haskellPackages.hnix ];
                builder = ./valid.sh;
                inherit src default;
              };
            in
            import valid.out;
          tryExtend = args: recursiveUpdate dfconf (tryImport args);

          bisect = cond: onTrue: onFalse:
            mkMerge [ (mkIf cond onTrue) (mkIf (! cond) onFalse) ];

          trisect = cond: onTrue: onFalse: always:
            mkMerge [ (mkIf cond onTrue) (mkIf (! cond) onFalse) always ];

          isDarwin = pkgs.stdenv.buildPlatform.isDarwin;

          bisectDarwin = bisect isDarwin;

          trisectDarwin = trisect isDarwin;
        };
      in
      full;

    mkOutputs = { dfconf, root, homeExtra ? [ ], nixosExtra ? [ ], darwinExtra ? [ ] }:
      let
        inherit (dfconf) userName hostName system hmMod;
        hm = mods:
          if hmMod
          then [
            mods.home-manager
            { home-manager.users.${userName}.imports = dotfileConfig.homeDefs; }
          ]
          else [ ];
        utils = init { inherit dfconf; };
        pkgs = import nixpkgs { inherit system; };
        rootExpr = if isPath root then import root else root;
        dotfileConfig = rootExpr { inherit utils dfconf; };
      in
      {
        homeConfigurations."${userName}@${hostName}" =
          homeManagerConfiguration {
            inherit pkgs;
            modules = dotfileConfig.homeDefs ++ homeExtra;
          };
        nixosConfigurations.${hostName} = nixosSystem {
          inherit system;
          modules = dotfileConfig.nixosDefs ++ nixosExtra ++ (hm home-manager.nixosModules);
        };
        darwinConfigurations.${hostName} = darwinSystem {
          inherit system;
          modules = dotfileConfig.darwinDefs ++ darwinExtra ++ (hm home-manager.darwinModules);
        };
      };

    flattenConfigs = foldl' recursiveUpdate { };
  };
in
utils
