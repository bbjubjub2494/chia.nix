{
  lib,
  cacert,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "chia";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "Chia-Network";
    repo = "chia-blockchain";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-ttwNWsSkuMpT2GRQCMDIVq9CfTsQiiQBmOOBqaQRVBA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "==" ">="

    cp ${cacert}/etc/ssl/certs/ca-bundle.crt mozilla-ca/cacert.pem
  '';

  nativeBuildInputs = [
    python3Packages.setuptools-scm
  ];

  # give a hint to setuptools-scm on package version
  SETUPTOOLS_SCM_PRETEND_VERSION = "v${version}";

  propagatedBuildInputs = with python3Packages; [
    aiofiles
    aiohttp
    aiosqlite
    anyio
    bitstring
    boto3
    blspy
    chiapos
    chiavdf
    chiabip158
    chia-rs
    click
    clvm
    clvm-rs
    clvm-tools
    clvm-tools-rs
    colorama
    colorlog
    concurrent-log-handler
    cryptography
    dnslib
    dnspython
    fasteners
    filelock
    keyrings-cryptfile
    psutil
    pyyaml
    setproctitle
    setuptools # needs pkg_resources at runtime
    sortedcontainers
    watchdog
    websockets
    zstd
  ];

  checkInputs = with python3Packages; [
    pythonImportsCheckHook
  ];

  meta = with lib; {
    homepage = "https://www.chia.net/";
    description = "Chia is a modern cryptocurrency built from scratch, designed to be efficient, decentralized, and secure.";
    license = with licenses; [asl20];
    maintainers = [];
    platforms = platforms.all;
  };
}
