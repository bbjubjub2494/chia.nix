inputs: final: prev: {
  chiaNix = final.callPackages ./packages { inherit inputs; };
}
