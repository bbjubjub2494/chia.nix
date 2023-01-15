# The flake file is the entry point for nix commands
{
  description = "A reproducible Nix package set for Chia";

  # Inputs are how Nix can use code from outside the flake during evaluation.
  inputs.fup.url = "github:gytis-ivaskevicius/flake-utils-plus/v1.3.1";
  inputs.flake-compat.url = "github:edolstra/flake-compat";
  inputs.flake-compat.flake = false;
  inputs.cat-admin-tool.url = "github:Chia-Network/CAT-admin-tool";
  inputs.cat-admin-tool.flake = false;

  # Outputs are the public-facing interface to the flake.
  outputs = { self, fup, nixpkgs, ... } @ inputs:
    fup.lib.mkFlake {
      inherit self inputs;

      overlays.default = import ./overlay.nix inputs;

      channels.nixpkgs.overlaysBuilder = _: [
        self.overlays.default
      ];

      outputsBuilder = channels: {
        formatter = channels.nixpkgs.nixpkgs-fmt;
        packages = channels.nixpkgs.chiaNix;
      };
    };
}
