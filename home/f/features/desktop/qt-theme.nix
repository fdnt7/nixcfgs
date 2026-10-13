{ pkgs, ... }:
let
  theme = "qtengine";
in
{
  # Lets Qt programs, Dolphin and Prism Launcher among them, take their
  # colours from the shell. Outside Plasma Qt has no theme of its own: it
  # draws light whatever the desktop prefers.
  #
  # qtengine is the platform theme the shell knows how to drive: when it
  # sees the variable below it writes ~/.config/qtengine/config.json and
  # keeps it pointed at the colour scheme it generates.
  home.packages = [ pkgs.qtengine ];

  # Puts the profile's Qt plugins on the search path, where the theme
  # plugin is found.
  qt.enable = true;

  # For programs started from the session, and for the shell's service,
  # which otherwise picks GTK's theme for whatever it launches.
  home.sessionVariables.QT_QPA_PLATFORMTHEME = theme;
  systemd.user.sessionVariables.QT_QPA_PLATFORMTHEME = theme;
}
