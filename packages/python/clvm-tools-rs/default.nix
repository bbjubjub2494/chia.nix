{ lib
, fetchFromGitHub
, buildPythonPackage
, rustPlatform
, pythonOlder
}:

buildPythonPackage rec {
  pname = "clvm-tools-rs";
  version = "0.1.39";
  disabled = pythonOlder "3.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Chia-Network";
    repo = "clvm_tools_rs";
    rev = version;
    hash = "sha256-TtUeS74ru/V6HTUNVk2vh347zrqCyx27oE1YZWje5PU=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-dhQSb2DiiNtA6ZGgLU9dawC3/VKtqQLVOlLNFIA2uPw=";
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
    maintainers = [];
  };
}
