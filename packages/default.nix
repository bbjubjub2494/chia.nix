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
  pkgs' = pkgs.extend (final: prev:
    {
      python3Packages = prev.python3Packages.override {
        overrides = final': prev':
          replaceOlderAttr prev' {
            chia-rs = final'.callPackage python/chia-rs { };
            clvm-tools-rs = final'.callPackage python/clvm-tools-rs { };
          };
      };
    }
    // replaceOlderAttr prev {
      # https://nixpk.gs/pr-tracker.html?pr=201542
      bladebit = final.callPackage ./bladebit { };

      # not suitable for Nixpkgs
      cat-admin-tool = final.callPackage ./cat-admin-tool {
        src = inputs.cat-admin-tool;
      };
      chia-beta = final.chia;
      chia-rc = final.chia;
      chia = final.callPackage ./chia { };
      chia-plotter = final.callPackage ./chia-plotter { };
    } // {
      chia-dev-tools = final.callPackage ./chia-dev-tools { };
    });
in
{
  inherit
    (pkgs')
    bladebit
    chia
    chia-beta
    chia-rc
    chia-dev-tools
    chia-plotter
    cat-admin-tool
    # FIXME: it's useful to export this but it's not a derivation

    python3Packages
    ;
}
