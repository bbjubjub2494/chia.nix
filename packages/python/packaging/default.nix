{ lib
, buildPythonPackage
, fetchPypi
, pyparsing
, pytestCheckHook
, pythonOlder
, pretend
, flit-core
}:

let
  packaging = buildPythonPackage rec {
    pname = "packaging";
    version = "23.0";
    format = "pyproject";

    disabled = pythonOlder "3.6";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-tq0pf4kH3g+i/hzL0m/a84f19Hxydf7fjM6J+ZRGz5c=";
    };

    nativeBuildInputs = [
      flit-core
    ];

    propagatedBuildInputs = [ pyparsing ];

    # Prevent circular dependency
    doCheck = false;

    passthru.tests = packaging.overridePythonAttrs (_: { doCheck = true; });

    meta = with lib; {
      description = "Core utilities for Python packages";
      homepage = "https://github.com/pypa/packaging";
      license = with licenses; [ bsd2 asl20 ];
      maintainers = with maintainers; [ bennofs ];
    };
  };
in
packaging
