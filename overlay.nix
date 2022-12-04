final: prev: let
  pkgs = final;
  python.overrides = final: prev: {
    blspy = final.callPackage packages/blspy {};
    chia-rs = final.callPackage packages/chia-rs {};
    chiapos = final.callPackage packages/chiapos {};
    chiavdf = final.callPackage packages/chiavdf {};
    clvm-tools = final.callPackage packages/clvm-tools {};
    clvm-tools-rs = final.callPackage packages/clvm-tools-rs {};
    typing-extensions = final.callPackage packages/typing-extensions {};
    cryptography = final.callPackage packages/cryptography {
      inherit (pkgs.darwin) libiconv;
      inherit (pkgs.darwin.apple_sdk.frameworks) Security;
      openssl = pkgs.openssl_1_1;
    };
  };
in {
  chiaNix = {
    chia-beta = final.callPackage packages/chia-beta {
      python3Packages = final.python3Packages.override {
        inherit (python) overrides;
      };
    };
    chia = final.callPackage packages/chia {
      python3Packages = final.python3Packages.override {
        inherit (python) overrides;
      };
    };
  };
}
