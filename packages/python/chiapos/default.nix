{
  stdenv,
  lib,
  substituteAll,
  fetchpatch,
  buildPythonPackage,
  fetchPypi,
  catch2,
  cmake,
  cxxopts,
  ghc_filesystem,
  pybind11,
  pytestCheckHook,
  pythonOlder,
  psutil,
  setuptools-scm,
}:
buildPythonPackage rec {
  pname = "chiapos";
  version = "1.0.11";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TMRf9549z3IQzGt5c53Rk1Vq3tdrpZ3Pqc8jhj4AKzo=";
  };

  patches = [
    # prevent CMake from trying to get libraries on the Internet
    (substituteAll {
      src = ./dont_fetch_dependencies.patch;
      inherit cxxopts ghc_filesystem;
      catch2_src = catch2.src;
      pybind11_src = pybind11.src;
    })
    # adjust use of setuptools to support version 68.2
    (fetchpatch {
      url = "https://github.com/Chia-Network/chiapos/commit/7f1f011788742c5e59d3b18fc007265bd8787dea.patch";
      hash = "sha256-L6k+jJv+4p3TlDMyzFr042bejw/C7pqcEwM+/+p1B+c=";
    })
  ];

  nativeBuildInputs = [cmake setuptools-scm];

  buildInputs = [pybind11];

  nativeCheckInputs = [
    psutil
    pytestCheckHook
  ];

  # A fix for cxxopts >=3.1
  postPatch = ''
    substituteInPlace src/cli.cpp \
      --replace "cxxopts::OptionException" "cxxopts::exceptions::exception"
  '';

  # CMake needs to be run by setuptools rather than by its hook
  dontConfigure = true;

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Chia proof of space library";
    homepage = "https://www.chia.net/";
    license = licenses.asl20;
    maintainers = [];
  };
}
