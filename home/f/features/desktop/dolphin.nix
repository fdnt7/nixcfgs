{ pkgs, ... }:
{
  # Graphical file manager, run outside Plasma: it needs its I/O plugins and
  # an icon theme brought along. There is no module for it.
  home.packages = [
    pkgs.kdePackages.dolphin
    pkgs.kdePackages.kio-extras
    pkgs.kdePackages.breeze-icons

    # Previews in the file list: of videos, of documents and raw photos,
    # and the newer picture formats such as HEIC and AVIF.
    pkgs.kdePackages.ffmpegthumbs
    pkgs.kdePackages.kdegraphics-thumbnailers
    pkgs.kdePackages.kimageformats
  ];
}
