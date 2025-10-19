# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  # example = pkgs.callPackage ./example { };
  zed-discord-presence = pkgs.callPackage ./zed-discord-presence.nix { };
  zed-wakatime = pkgs.callPackage ./zed-wakatime.nix { };
}
