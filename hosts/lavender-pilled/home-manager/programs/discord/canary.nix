{ pkgs, ... }:
{
  # discord canary is stuck at installing update with openasar enabled
  # Refs: https://github.com/NixOS/nixpkgs/issues/515106
  home.packages = [
    pkgs.discord-canary
    # (pkgs.discord-canary.override { withOpenASAR = true; })
  ];
}
