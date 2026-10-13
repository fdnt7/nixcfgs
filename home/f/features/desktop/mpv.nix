{ config, ... }:
{
  # Video and audio player: keyboard-driven, started from yazi or a
  # terminal.
  programs.mpv.enable = true;

  xdg.mimeApps.defaultApplicationPackages = [ config.programs.mpv.finalPackage ];
}
