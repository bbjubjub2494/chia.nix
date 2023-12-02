{ inputs, pkgs }:
let
  replaceOlder = refPkg: altPkg:
    if pkgs.lib.versionOlder (pkgs.lib.getVersion refPkg) (pkgs.lib.getVersion altPkg)
    then altPkg
    else pkgs.lib.warn "chia.nix: not replacing ${pkgs.lib.getName refPkg} ${pkgs.lib.getVersion refPkg} with ${pkgs.lib.getName altPkg} ${pkgs.lib.getVersion altPkg} because it's not older" refPkg;
  replaceOlderAttr = refs: alts:
    pkgs.lib.mapAttrs
      (name: pkg:
        if pkgs.lib.hasAttr name refs
        then replaceOlder (pkgs.lib.getAttr name refs) pkg
        else pkg)
      alts;
in
pkgs.extend (final: prev:
{
  python3Packages = prev.python3Packages.override {
    overrides = final': prev':
      {
        based58 = final'.callPackage python/based58 { };
        blspy = final'.callPackage python/blspy { };
        chia-rs = final'.callPackage python/chia-rs { };
        chiabip158 = final'.callPackage python/chiabip158 { };
        chiavdf = final'.callPackage python/chiavdf { };
        chiapos = final'.callPackage python/chiapos { };
        clvm = final'.callPackage python/clvm { };
        clvm-rs = final'.callPackage python/clvm-rs { };
        clvm-tools = final'.callPackage python/clvm-tools { };
        clvm-tools-rs = final'.callPackage python/clvm-tools-rs { };
      };
  };
  chia-dev-tools = final.callPackage ./chia-dev-tools { };

  # https://nixpk.gs/pr-tracker.html?pr=201542
  bladebit = final.callPackage ./bladebit { };

  # not suitable for Nixpkgs
  cat-admin-tool = final.callPackage ./cat-admin-tool {
    src = inputs.cat-admin-tool;
  };
  chia = final.callPackage ./chia { };
  chia-beta = final.callPackage ./chia-beta { };
  chia-rc = final.callPackage ./chia-rc { };
  chia-plotter = final.callPackage ./chia-plotter { };
  dexie-rewards = final.callPackage ./dexie-rewards { };
})
