{ nixpkgs, dfconf }:
let
  inherit (nixpkgs) lib;
  inherit (dfconf) userName;
  self = with lib; {
    dualDefinitions = { hostDefinitions, userDefinitions }:
      hostDefinitions // { home-manager.users.${userName}.imports = [ userDefinitions ]; };
    userDefinitions = definitions: { home-manager.users.${userName}.imports = [ definitions ]; };
    homePath = { userName, ... }: path: [ "home-manager" "users" "${userName}" ] ++ path;
    condDefinitions = path: default: pred: definitions:
      let
        val = attrByPath path default dfconf;
        enable = pred val;
      in
      mkIf enable definitions;
    boolDefinitions = path: self.condDefinitions path false (v: assert builtins.isBool v; v);
    boolDefinitions' = path: self.condDefinitions path false (v: assert builtins.isBool v; !v);
    enumDefinitions = path: val: self.condDefinitions path null (v: v == val);
    enumDefinitions' = path: val: self.condDefinitions path null (v: v != val);
    mkEnumOption = enumVal: mkOption { type = with types; nullOr (enum [ enumVal ]); };
  };
in
self
