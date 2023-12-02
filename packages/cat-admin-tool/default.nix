{
  lib,
  fetchFromGitHub,
  python3Packages,
  chia,
}:
python3Packages.buildPythonApplication rec {
  pname = "CAT-admin-tool";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "Chia-Network";
    repo = "CAT-admin-tool";
    rev = "b9348399b1885aa94069f6ea4e1ec9960fefb05e";
    hash = "sha256-+C0nw8VmyAGSFdcXNQSc0WJvkGK/IiPpyfR63hZd7NI=";
  };

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
    license = with licenses; [asl20];
    maintainers = [];
    platforms = platforms.all;
  };
}
