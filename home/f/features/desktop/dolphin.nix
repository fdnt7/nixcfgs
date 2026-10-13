{
  config,
  lib,
  pkgs,
  ...
}:
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

  # KDE programs learn which applications exist from a menu definition,
  # which Plasma ships and nothing here does. Without one Dolphin knows of
  # no program to open a file with. This one lists every installed
  # application.
  xdg.configFile."menus/applications.menu".text = ''
    <!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN"
      "http://www.freedesktop.org/standards/menu-spec/menu-1.0.dtd">
    <Menu>
      <Name>Applications</Name>
      <DefaultAppDirs/>
      <DefaultDirectoryDirs/>
      <DefaultMergeDirs/>
      <Include>
        <All/>
      </Include>
    </Menu>
  '';

  # KDE caches what it found and refreshes the cache when a directory it
  # read looks newer. Here those are links into the Nix store, where every
  # file is dated 1970, so a new program never shows. Drop the cache on
  # each switch, as NixOS does at login under Plasma; it is rebuilt when
  # next needed.
  home.activation.dropKdeServiceCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run rm -f $VERBOSE_ARG ${lib.escapeShellArg config.xdg.cacheHome}/ksycoca6_*
  '';
}
