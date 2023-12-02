{
  fetchPypi,
  python3Packages,
  rustPlatform,
  ...
}:
python3Packages.buildPythonApplication rec {
  pname = "based58";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-gIBLNGs0GWyJ3Ho9yJtgIfkQ9M11qsQdQzyhiAsWctw=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
    touch LICENSE
  '';

  format = "pyproject";

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
    python3Packages.poetry-core
  ];
}
