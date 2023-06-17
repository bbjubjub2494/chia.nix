# The flake file is the entry point for nix commands
{
  description = "A reproducible Nix package set for Chia";

  # Inputs are how Nix can use code from outside the flake during evaluation.
  inputs.hercules-ci-effects.url = "github:hercules-ci/hercules-ci-effects";
  inputs.hercules-ci-effects.inputs.nixpkgs.follows = "nixpkgs";
  inputs.flake-compat.url = "github:edolstra/flake-compat";
  inputs.flake-compat.flake = false;
  inputs.cat-admin-tool.url = "github:Chia-Network/CAT-admin-tool";
  inputs.cat-admin-tool.flake = false;

  nixConfig.extra-substituters = "https://chia-nix.cachix.org";
  nixConfig.extra-trusted-public-keys = "chia-nix.cachix.org-1:Zf5INmp8F07mHCCslASHUx7ue+GbwxxV5Uw7e5DdUDI=";


  # Outputs are the public-facing interface to the flake.
  outputs = { self, flake-parts, nixpkgs, ... } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.hercules-ci-effects.flakeModule
      ];

      systems = [ "x86_64-linux" "aarch64-linux" ];

      perSystem = { pkgs, ... }:
        let
          pkgs' = import ./packages { inherit inputs pkgs; };
        in
        {
          formatter = pkgs.nixpkgs-fmt;
          packages = {
            inherit
              (pkgs')
              bladebit
              chia
              chia-beta
              chia-rc
              chia-dev-tools
              chia-plotter
              cat-admin-tool
              dexie-rewards
              ;
          };

          legacyPackages = {
            inherit (pkgs') python3Packages;
          };
        };

      hercules-ci.flake-update.enable = true;
      hercules-ci.flake-update.when.dayOfWeek = "Sat";
    };
}
