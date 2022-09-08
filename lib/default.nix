{ nixpkgs }:
let
  inherit (nixpkgs) lib;
  takeDefaults = [ [ "dualDefinitions" ] [ "userDefinitions" ] [ "homePath" ] ];
  self = with lib; {
    dualDefinitions = { userName, ... }: { hostDefinitions, userDefinitions }:
      hostDefinitions // { home-manager.users.${userName}.imports = [ userDefinitions ]; };
    userDefinitions = { userName, ... }: definitions: { home-manager.users.${userName}.imports = [ definitions ]; };
    homePath = { userName, ... }: path: [ "home-manager" "users" "${userName}" ] ++ path;
    /* boolModule = { path, definitions, imports ? [ ], extraDeclarations ? { } }:
      { config, ... }:
      let
        enable = getAttrFromPath path config;
        optDec = mkOption { type = types.bool; default = false; };
      in
      {
        imports =
          if enable then imports else [ ];
        options = recursiveUpdate (setAttrByPath path optDec) extraDeclarations;
        config = mkIf enable definitions;
      };
      enumModule = { path, enumVal, definitions, imports ? [ ], extraDeclarations ? { } }:
      { config, ... }:
      let
        enable = (getAttrFromPath path config) == enumVal;
        optDec = mkOption { type = with types; nullOr (enum [ enumVal ]); };
      in
      {
        imports = if enable then imports else [ ];
        options = recursiveUpdate (setAttrByPath path optDec) extraDeclarations;
        config = mkIf enable definitions;
      }; */
    mkEnumOption = enumVal: mkOption { type = with types; nullOr (enum [ enumVal ]); };
    setDefaults = defaults:
      let
        updates = map (path: { inherit path; update = old: old defaults; }) takeDefaults;
      in
      updateManyAttrsByPath updates self;
  };
in
self
