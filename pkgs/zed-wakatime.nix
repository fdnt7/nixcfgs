{pkgs}:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "wakatime-ls";
  version = "57e2c52a5f7133e028f97d8cbbac3b1479ed5088";
  cargoHash = "sha256-+dVID7S5EHI4BkVi9MD1Vhe287bhRE4UlqTJN50Rmzc=";

  src = pkgs.fetchFromGitHub {
    owner = "wakatime";
    repo = "zed-wakatime";
    rev = version;
    hash = "sha256-wSgN4vycTH+Rgsl5LtkcsDfnZnpM5jsTKMmKdjwRBqs=";
  };

  cargoBuildFlags = "--package wakatime-ls";
}
