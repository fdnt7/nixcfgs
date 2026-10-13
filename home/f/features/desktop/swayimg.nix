{ config, ... }:
{
  # Image viewer, as on the older Hyprland host: small and keyboard-driven.
  programs.swayimg.enable = true;

  xdg.mimeApps.defaultApplicationPackages = [ config.programs.swayimg.package ];
}
