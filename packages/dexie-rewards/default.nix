{
  system,
  fetchzip,
  python3Packages,
  chia,
  ...
}:
python3Packages.buildPythonApplication rec {
  pname = "dexie-rewards";
  version = "1.8.1";

  src = fetchzip {
    url = "https://pypi.io/packages/source/d/dexie-rewards/dexie_rewards-${version}.tar.gz";
    sha256 = "sha256-yDQgUpzt4M/FTO4rJ/imNOfOTeHq5lRMvzj9py+iDzk=";
  };
  format = "pyproject";

  postPatch = ''
    sed '/aiosqlite/d' -i pyproject.toml
  '';

  nativeBuildInputs = with python3Packages; [
    poetry-core
  ];

  propagatedBuildInputs = with python3Packages; [
    based58
    aiomisc
    aiosqlite
    chia
    rich-click
  ];
}
