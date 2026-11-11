{ config, ... }:
{
  # Image viewer: small and keyboard-driven. Left and Right step through
  # the pictures, where swayimg, used before, pans the one shown.
  programs.imv.enable = true;

  # The package has two entries claiming the same types: imv, showing
  # only the file it was given, and imv-dir, which also takes in the
  # rest of its folder to step through. imv-dir sorts first, so it is
  # the one that opens pictures.
  xdg.mimeApps.defaultApplicationPackages = [ config.programs.imv.package ];
}
