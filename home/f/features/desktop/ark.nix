{ pkgs, ... }:
{
  # Archive manager, the one Dolphin is made to work with: it opens
  # archives to browse them and adds extracting and compressing to
  # Dolphin's context menu. There is no module for it.
  home.packages = [ pkgs.kdePackages.ark ];

  # Without it, Dolphin was left to choose among the programs that claim
  # zip files for other reasons, and chose Prism Launcher, which takes
  # them as modpacks.
  xdg.mimeApps.defaultApplicationPackages = [ pkgs.kdePackages.ark ];
}
