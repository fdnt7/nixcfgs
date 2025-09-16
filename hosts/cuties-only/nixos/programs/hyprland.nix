{
  inputs,
  pkgs,
  ...
}: let
  hyprlandPkgs = inputs.hyprland.packages;
in {
  programs.hyprland = {
    enable = true;
    withUWSM = true; # recommended for most users
    xwayland.enable = true; # Xwayland can be disabled.
    package = hyprlandPkgs.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = hyprlandPkgs.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
}
