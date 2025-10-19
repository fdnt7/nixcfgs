{ pkgs }:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "discord-presence-lsp";
  version = "ce2241b5c78d797155e316e2e6f399669595522d";
  cargoHash = "sha256-1lcnw79UURe7LUuV2q9+CwUzVxG34J6cAxIgORbjLnU=";

  src = pkgs.fetchFromGitHub {
    owner = "xhyrom";
    repo = "zed-discord-presence";
    rev = version;
    hash = "sha256-3sG5FKaa2x+aeRIq4tyKgoLSUTbt5YjXbN6eXf6A8tA=";
  };

  cargoBuildFlags = "--package discord-presence-lsp";
}
