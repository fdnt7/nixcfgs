{ inputs, pkgs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  # Spotify, patched by Spicetify to load extensions; this one skips ads.
  programs.spicetify = {
    enable = true;
    enabledExtensions = [ spicePkgs.extensions.adblock ];
  };
}
