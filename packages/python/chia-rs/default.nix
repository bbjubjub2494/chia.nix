{ buildPythonPackage
, lib
, fetchFromGitHub
, pytestCheckHook
, rustPlatform
, clvm-tools
}:
buildPythonPackage rec {
  pname = "chia-rs";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "chia-network";
    repo = "chia_rs";
    rev = version;
    hash = "sha256-347xWrthM/8AzkfJt6MViH60jq1S4OydD14Je2RKnBc=";
  };

  patches = [
    # undo a hack from upstream that confuses our build hook
    ./fix-build.patch
  ];

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  preBuild = ''
    # avoid ENOENT in maturinBuildHook
    touch wheel/Cargo.lock
  '';

  checkInputs = [
    pytestCheckHook
    clvm-tools
  ];

  buildAndTestSubdir = "wheel";

  meta = with lib; {
    description = "Rust crate & wheel with consensus code";
    homepage = "https://github.com/Chia-Network/chia_rs/";
    license = licenses.asl20;
    maintainers = teams.chia.members;
  };
}
