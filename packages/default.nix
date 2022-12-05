{pkgs}: let
  replaceOlder = refPkg: altPkg:
    if pkgs.lib.versionOlder (pkgs.lib.getVersion refPkg) (pkgs.lib.getVersion altPkg)
    then altPkg
    else pkgs.lib.warn "chia.nix: not replacing ${refPkg} with ${altPkg} because it's not older" refPkg;
  replaceOlderAttr = refs: alts:
    pkgs.lib.mapAttrs (name: pkg:
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
            blspy = final'.callPackage ./blspy {};
            chia-rs = final'.callPackage ./chia-rs {};
            chiapos = final'.callPackage ./chiapos {};
            chiavdf = final'.callPackage ./chiavdf {};
            clvm-tools = final'.callPackage ./clvm-tools {};
            clvm-tools-rs = final'.callPackage ./clvm-tools-rs {};

            # https://nixpk.gs/pr-tracker.html?pr=202239
            typing-extensions = final'.callPackage ./typing-extensions {};

            # https://nixpk.gs/pr-tracker.html?pr=202242
            cryptography = final'.callPackage ./cryptography {
              inherit (final.darwin) libiconv;
              inherit (final.darwin.apple_sdk.frameworks) Security;
              openssl = final.openssl_1_1;
            };
          };
      };
    }
    // replaceOlderAttr prev {
      chia-beta = final.callPackage ./chia-beta {};
      chia = final.callPackage ./chia {};
      chia-dev-tools = final.callPackage ./chia-dev-tools {};
    });
in {
  inherit
    (pkgs')
    chia
    chia-beta
    chia-dev-tools
    # FIXME: it's useful to export this but it's not a derivation
    python3Packages
    ;
}
