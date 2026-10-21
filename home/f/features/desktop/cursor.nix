{ config, pkgs, ... }:
let
  cursor = config.home.pointerCursor;
in
{
  # niri asks for the size times the scale rounded up, 2 on fw16's 1.25, and
  # takes the nearest image Posy has: 32, 48, 64 and so on. 24 gets the one
  # drawn at 150%, shown at 125%; Posy's own base of 32 gets the 200% one,
  # a size larger. The variants drawn for 125% and 175% are never asked for.
  home.pointerCursor = {
    enable = true;
    package = pkgs.posy-cursors;
    name = "Posy_Cursor_Black";
    size = 24;
    # For GTK 3 programs, which read it from their settings and from dconf
    # rather than asking the compositor for a cursor by name.
    gtk.enable = true;
  };
  gtk.enable = true;

  # niri draws the cursor for every program that asks it to by name, and
  # passes the theme on to those it starts. It reads neither from the
  # environment, so it is told here.
  wayland.windowManager.niri.extraConfig = ''
    cursor {
        xcursor-theme "${cursor.name}"
        xcursor-size ${toString cursor.size}
    }
  '';
}
