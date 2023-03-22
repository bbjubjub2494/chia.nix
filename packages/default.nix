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
      replaceOlderAttr prev'
        {
          aiofiles = final'.callPackage python/aiofiles { };
          aiohttp = final'.callPackage python/aiohttp { };
          chia-rs = final'.callPackage python/chia-rs { };
          packaging = final'.callPackage python/packaging { };
          typing-extensions = final'.callPackage python/typing-extensions { };
          zstd = final'.callPackage python/zstd { inherit (final) zstd; };
        } // {
        build = final'.callPackage python/build { };
      };
  };
} // replaceOlderAttr prev {
  # https://nixpk.gs/pr-tracker.html?pr=201542
  bladebit = final.callPackage ./bladebit { };

  # not suitable for Nixpkgs
  cat-admin-tool = final.callPackage ./cat-admin-tool {
    src = inputs.cat-admin-tool;
  };
  chia = final.callPackage ./chia { };
  chia-beta = final.callPackage ./chia-beta { };
  chia-rc = final.chia;
  chia-plotter = final.callPackage ./chia-plotter { };
})
