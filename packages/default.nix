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
          based58 = final'.callPackage python/based58 { };
          boto3 = final'.callPackage python/boto3 { };
          botocore = final'.callPackage python/botocore { };
          chia-rs = final'.callPackage python/chia-rs { };
          chiavdf = final'.callPackage python/chiavdf { };
          typing-extensions = final'.callPackage python/typing-extensions { };
          zstd = final'.callPackage python/zstd { inherit (final) zstd; };
        } // {
        twisted = prev'.twisted.overrideAttrs (_: { doInstallCheck = false; });
      };
  };
  chia-dev-tools = final.callPackage ./chia-dev-tools { };
} // replaceOlderAttr prev {
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
