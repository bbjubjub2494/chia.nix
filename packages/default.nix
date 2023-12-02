{
  inputs,
  pkgs,
}: let
  inherit (pkgs) lib;
  collect = dir:
    if !builtins.pathExists dir
    then {}
    else
      lib.concatMapAttrs
      (name: type:
        if type == "directory" && builtins.pathExists (dir + "/${name}/default.nix")
        then {${name} = dir + "/${name}";}
        else {})
      (builtins.readDir dir);
in
  pkgs.extend (final: prev:
    {
      python3Packages = prev.python3Packages.override {
        overrides = final': prev':
          lib.mapAttrs (_: path: final'.callPackage path {}) (collect ./python);
      };
    }
    // lib.mapAttrs (_: path: final.callPackage path {}) (collect ./.))
