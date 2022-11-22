{ nixpkgs, home-manager }:
let
  inherit (nixpkgs.lib)
    attrByPath mkIf mkOption types nixosSystem recursiveUpdate;
  inherit (home-manager.lib) homeManagerConfiguration;
  inherit (builtins) isBool isPath foldl';
  utils = rec {
    init = { dfconf }:
      let
        inherit (dfconf) system;
        pkgs = import nixpkgs { inherit system; };
        inherit (pkgs) stdenvNoCC haskellPackages;
      in
      utils // rec {

        mkDefs = { imports ? [ ], homeDefs ? (_: { }), hostDefs ? (_: { }) }:
          let
            imported = map (p: assert isPath p; import p) imports;
            merge = { homeI, hostI }: { home, host }:
              { homeI = homeI ++ [ home ]; hostI = hostI ++ [ host ]; };

            imports' = foldl' merge { homeI = [ ]; hostI = [ ]; } (map mkDefs imported);
            extend = old: imps: old // { imports = (old.imports or [ ]) ++ imps; };
          in
          {
            home = extend (homeDefs { inherit utils dfconf; }) imports'.homeI;
            host = extend (hostDefs { inherit utils dfconf; }) imports'.hostI;
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
      };

    mkOutputs = { dfconf, root, homeExtra ? [ ], hostExtra ? [ ] }:
      let
        inherit (dfconf) userName hostName system;
        utils = init { inherit dfconf; };
        pkgs = import nixpkgs { inherit system; };
        metaConfig = (import root) { inherit utils dfconf; };
      in
      {
        nixosConfigurations.${hostName} =
          nixosSystem { inherit system pkgs; modules = [ metaConfig.host ] ++ hostExtra; };
        homeConfigurations."${userName}@${hostName}" =
          homeManagerConfiguration { inherit pkgs; modules = [ metaConfig.home ] ++ homeExtra; };
      };

    flattenConfigs = foldl' recursiveUpdate { };
  };
in
utils
