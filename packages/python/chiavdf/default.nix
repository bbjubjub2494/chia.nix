{
  lib,
  stdenv,
  buildPythonPackage,
  fetchpatch,
  fetchPypi,
  setuptools-scm,
  substituteAll,
  cmake,
  boost,
  gmp,
  pybind11,
  pytestCheckHook,
  pythonOlder,
}:
buildPythonPackage rec {
  pname = "chiavdf";
  version = "1.0.9";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-G4npp0G8TNk2y/T6myNr8NCfkBdcknsWds+XBZiNnQY=";
  };

  patches = [
    # prevent CMake from trying to get libraries on the Internet
    (substituteAll {
      src = ./dont_fetch_dependencies.patch;
      pybind11_src = pybind11.src;
    })
    # adjust use of setuptools to support version 68.2
    (fetchpatch {
      url = "https://github.com/Chia-Network/chiavdf/commit/7c6a7680dc8ce4386a60058e61fa7cb3526595e1.patch";
      hash = "sha256-80w3MDLdcjHKNFCp9vJ4SCFVjlPKZzQgXrDLB8OHdJE=";
    })
  ];

  # x86 instructions are needed for this component
  BUILD_VDF_CLIENT = lib.optionalString (!stdenv.isx86_64) "N";

  nativeBuildInputs = [cmake setuptools-scm];

  buildInputs = [boost gmp pybind11];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # CMake needs to be run by setuptools rather than by its hook
  dontConfigure = true;

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Chia verifiable delay function utilities";
    homepage = "https://www.chia.net/";
    license = licenses.asl20;
    maintainers = [];
  };
}
