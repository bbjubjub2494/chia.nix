{pkgs}: let
  pkgs' = pkgs.extend (final: prev: {
    python3Packages = prev.python3Packages.override {
      overrides = final': prev': {
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
    ;
}
