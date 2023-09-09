{ lib
, src
, fetchFromGitHub
, python3Packages
, chia
,
}:
python3Packages.buildPythonApplication rec {
  pname = "CAT-admin-tool";
  version = "unstable";

  inherit src;

  postPatch = ''
    substituteInPlace setup.py \
      --replace "==" ">="
  '';

  nativeBuildInputs = [
    python3Packages.setuptools-scm
  ];

  # give a hint to setuptools-scm on package version
  SETUPTOOLS_SCM_PRETEND_VERSION = "v${version}";

  propagatedBuildInputs = with python3Packages; [
    (toPythonModule chia)
    pytest-asyncio
  ];

  checkInputs = with python3Packages; [
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://www.chia.net/";
    description = "Admin tool for issuing CATs";
    license = with licenses; [ asl20 ];
    maintainers = teams.chia.members;
    platforms = platforms.all;
  };
}
