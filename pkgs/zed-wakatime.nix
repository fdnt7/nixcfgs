{ pkgs }:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "wakatime-ls";
  version = "8106d78fadc1dc0d255fd14662b031d56aac0f57";
  cargoHash = "sha256-x2axmHinxYZ2VEddeCTqMJd8ok0KgAVdUhbWaOdRA30=";

  src = pkgs.fetchFromGitHub {
    owner = "wakatime";
    repo = "zed-wakatime";
    rev = version;
    hash = "sha256-60TAw/3i0O/RldKkCYV4C6B/sSI0li+nxIV0aVyFL6s=";
  };

  cargoBuildFlags = "--package wakatime-ls";
}
