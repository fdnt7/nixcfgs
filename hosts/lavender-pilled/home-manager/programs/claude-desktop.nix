{ inputs, pkgs, ... }:
{
  nixpkgs.overlays = [ inputs.claude-desktop.overlays.default ];
  home.packages = [ pkgs.claude-desktop ];
}
