{ pkgs }:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "wakatime-ls";
  version = "d32a179962a28e714871bee09ba9f7a551163d3b";
  cargoHash = "sha256-x2axmHinxYZ2VEddeCTqMJd8ok0KgAVdUhbWaOdRA30=";

  src = pkgs.fetchFromGitHub {
    owner = "wakatime";
    repo = "zed-wakatime";
    rev = version;
    hash = "sha256-q9iWy4tt1M+0V4mXOwdhuNJMK1OpqpPQIicEyZJZj0g=";
  };

  cargoBuildFlags = "--package wakatime-ls";
}
