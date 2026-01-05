{ pkgs }:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "wakatime-ls";
  version = "ca28a7b3051f0553e8486f7b3efd651cd79d7de8";
  cargoHash = "sha256-x2axmHinxYZ2VEddeCTqMJd8ok0KgAVdUhbWaOdRA30=";

  src = pkgs.fetchFromGitHub {
    owner = "wakatime";
    repo = "zed-wakatime";
    rev = version;
    hash = "sha256-yseJSt1Tv3R9K8ERSvvne5FTG73DJbpfhd3a7QJAVik=";
  };

  cargoBuildFlags = "--package wakatime-ls";
}
