{ pkgs }:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "wakatime-ls";
  version = "322b24666fb7731dbda0a1e62b69f8d19195e7c3";
  cargoHash = "sha256-avOyVRYiI+BuE/c97vmlrWzD/Hbu9SzPdR7i0YTtOk4=";

  src = pkgs.fetchFromGitHub {
    owner = "wakatime";
    repo = "zed-wakatime";
    rev = version;
    hash = "sha256-fF+J9/dTTZriFjD24JoTiobjPSXMVFqe8fyl+ACB5HE=";
  };

  cargoBuildFlags = "--package wakatime-ls";
}
