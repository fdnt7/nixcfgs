{ pkgs, ... }:
{
  # Graphical file manager, run outside Plasma: it needs its I/O plugins and
  # an icon theme brought along. There is no module for it.
  home.packages = [
    pkgs.kdePackages.dolphin
    pkgs.kdePackages.kio-extras
    pkgs.kdePackages.breeze-icons
  ];
}
