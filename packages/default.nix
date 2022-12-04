{pkgs}: let
  pkgs' = pkgs.extend (final: prev: {
    python3Packages = prev.python3Packages.override {
      overrides = final': prev': {
        blspy = final'.callPackage ./blspy {};
        chia-rs = final'.callPackage ./chia-rs {};
        chiapos = final'.callPackage ./chiapos {};
        chiavdf = final'.callPackage ./chiavdf {};
        clvm-tools = final'.callPackage ./clvm-tools {};
        clvm-tools-rs = final'.callPackage ./clvm-tools-rs {};
        typing-extensions = final'.callPackage ./typing-extensions {};
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
