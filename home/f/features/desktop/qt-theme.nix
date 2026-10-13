{ config, pkgs, ... }:
let
  theme = "qtengine";
in
{
  # Lets Qt programs, Dolphin and Prism Launcher among them, take their
  # colours from the shell. Outside Plasma Qt has no theme of its own: it
  # draws light whatever the desktop prefers.
  home.packages = [
    (pkgs.qtengine.overrideAttrs (old: {
      # Toolbars drawn by Breeze, as in Dolphin, otherwise keep their
      # colours when the shell switches between light and dark.
      patches = (old.patches or [ ]) ++ [ ./qtengine-refresh-breeze-scheme.patch ];
    }))
  ];

  # Puts the profile's Qt plugins on the search path, where the theme
  # plugin is found.
  qt.enable = true;

  # For programs started from the session, and for the shell's service,
  # which otherwise picks GTK's theme for whatever it launches.
  home.sessionVariables.QT_QPA_PLATFORMTHEME = theme;
  systemd.user.sessionVariables.QT_QPA_PLATFORMTHEME = theme;

  xdg.configFile."qtengine/config.json" = {
    # The shell wrote one of its own before this was declared.
    force = true;
    text = builtins.toJSON {
      # The scheme the shell regenerates whenever its theme or its light
      # and dark mode changes. qtengine watches the file, so programs that
      # are running follow along.
      theme.colorScheme = "${config.xdg.dataHome}/color-schemes/DankMatugen.colors";

      # Open with a double click; qtengine's default is a single one.
      misc.singleClickActivate = false;
    };
  };
}
