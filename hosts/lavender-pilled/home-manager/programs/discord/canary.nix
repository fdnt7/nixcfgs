{ pkgs, ... }:
{
  home.packages = [
    (pkgs.discord-canary
      # openASAR made discord unable to play GIFs or videos
      #
      # Refs: https://github.com/NixOS/nixpkgs/issues/507233
      # .override { withOpenASAR = true; }
    )
  ];
}
