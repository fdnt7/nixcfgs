{ pkgs }:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "discord-presence-lsp";
  version = "e6f41ae3cbd2a7fcde1001a746422cdc673df8f3";
  cargoHash = "sha256-HNyxaiX+nHnWqu3TZmNbmazT9GkQTukbHTz+7kJXEDo=";

  src = pkgs.fetchFromGitHub {
    owner = "xhyrom";
    repo = "zed-discord-presence";
    rev = version;
    hash = "sha256-7CDR4gMFKg5dWgy8zgPt0vz3vkUH8ZXrbnRq84wKD7w=";
  };

  cargoBuildFlags = "--package discord-presence-lsp";
}
