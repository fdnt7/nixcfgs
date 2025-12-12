{ pkgs }:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "wakatime-ls";
  version = "379b2092cea447bcae910778ef8aadf48cc12940";
  cargoHash = "sha256-x2axmHinxYZ2VEddeCTqMJd8ok0KgAVdUhbWaOdRA30=";

  src = pkgs.fetchFromGitHub {
    owner = "wakatime";
    repo = "zed-wakatime";
    rev = version;
    hash = "sha256-x0sZxf3maFT+jEufcJCTJBpGrsE+soibLvuFYkBwzXw=";
  };

  cargoBuildFlags = "--package wakatime-ls";
}
