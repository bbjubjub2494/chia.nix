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
            # https://nixpk.gs/pr-tracker.html?pr=200769
            blspy = final'.callPackage python/blspy { };
            chia-rs = final'.callPackage python/chia-rs { };
            chiapos = final'.callPackage python/chiapos { };
            chiavdf = final'.callPackage python/chiavdf { };
            clvm-tools = final'.callPackage python/clvm-tools { };
            clvm-tools-rs = final'.callPackage python/clvm-tools-rs { };

            # https://nixpk.gs/pr-tracker.html?pr=202239
            typing-extensions = final'.callPackage python/typing-extensions { };

            # https://nixpk.gs/pr-tracker.html?pr=209180
            watchdog = final'.callPackage python/watchdog { CoreServices = null; };
          };
      };
    }
    // replaceOlderAttr prev rec {
      # https://nixpk.gs/pr-tracker.html?pr=208955
      chia = final.callPackage ./chia { };

      # https://nixpk.gs/pr-tracker.html?pr=210765
      chia-dev-tools = final.callPackage ./chia-dev-tools { };

      # not suitable for Nixpkgs
      cat-admin-tool = final.callPackage ./cat-admin-tool {
        src = inputs.cat-admin-tool;
      };
      chia-beta = final.callPackage ./chia-beta { };
      chia-rc = chia;
    });
in
{
  inherit
    (pkgs')
    chia
    chia-beta
    chia-rc
    chia-dev-tools
    cat-admin-tool
    # FIXME: it's useful to export this but it's not a derivation

    python3Packages
    ;
}
