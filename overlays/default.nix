# This file defines overlays
{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications =
    final: prev:
    let
      pinnedPkgs = import inputs.nixpkgs-14b7d17 {
        system = final.stdenv.hostPlatform.system;
        config = prev.config;
      };
    in
    {
      # example = prev.example.overrideAttrs (oldAttrs: rec {
      # ...
      # });

      claude-code = pinnedPkgs.claude-code;
    };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
