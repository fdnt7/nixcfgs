{ pkgs, ... }:
{
  home.packages = [ (pkgs.discord-canary.override { withOpenASAR = true; }) ];
}
