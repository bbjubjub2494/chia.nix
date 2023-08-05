{ lib
, fetchFromGitHub
, buildPythonPackage
, rustPlatform
, pythonOlder
}:

buildPythonPackage rec {
  pname = "clvm-tools-rs";
  version = "0.1.34";
  disabled = pythonOlder "3.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Chia-Network";
    repo = "clvm_tools_rs";
    rev = version;
    hash = "sha256-0qxlA973EjKKUOhTbNMd7ig4R+4wQUS0XZiPAMQBFxM=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-XpC5cbp9+U17PSBBbhWsq5Fl24xhIdrwmai48UP3ihE=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  pythonImportsCheck = [ "clvm_tools_rs" ];

  meta = with lib; {
    homepage = "https://chialisp.com/";
    description = "Rust port of clvm_tools";
    license = licenses.asl20;
    maintainers = teams.chia.members;
  };
}
