rec {
  mkUtils = { nixpkgs, dfconf }:
    let
      inherit (nixpkgs.lib) attrByPath mkIf mkOption types;
      inherit (builtins) isBool isPath foldl';
      utils = rec {

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
      };
    in
    utils;

  /*
    > mkDefs { ...; dfconf = { ... }; root = ({ utils, dfconf }: { ... } ) }
    > { nixosConfigurations = { ... }; homeConfigurations = { ... }}
  */

  mkOutputs = { nixpkgs, home-manager, dfconf, root, homeExtra ? [ ], hostExtra ? [ ] }:
    let
      inherit (dfconf) userName hostName system;
      inherit (nixpkgs.lib) nixosSystem;
      inherit (home-manager.lib) homeManagerConfiguration;

      utils = mkUtils { inherit nixpkgs dfconf; };
      pkgs = import nixpkgs { inherit system; };
      metaConfig = (import root) { inherit utils dfconf; };
    in
    {
      nixosConfigurations.${hostName} =
        nixosSystem { inherit system pkgs; modules = [ metaConfig.host ] ++ hostExtra; };
      homeConfigurations."${userName}@${hostName}" =
        homeManagerConfiguration { inherit pkgs; modules = [ metaConfig.home ] ++ homeExtra; };
    };

  /*
    > mapConfigs { ...; root = ({ utils, dfconf }: { ... } ); configs = [ { dfconf = { ... }; homeExtra = [ ... ]; hostExtra = [ ... ]; } ]; }
    > { nixosConfigurations = { ... }; homeConfigurations = { ... }; }
  */

  mapConfigs = { nixpkgs, home-manager, root, configs }:
    let
      inherit (builtins) foldl';
      inherit (nixpkgs.lib) recursiveUpdate;
      individual = map
        ({ dfconf, homeExtra ? [ ], hostExtra ? [ ] }:
          mkOutputs { inherit nixpkgs home-manager dfconf root homeExtra hostExtra; })
        configs;
    in
    foldl' recursiveUpdate { } individual;
}
