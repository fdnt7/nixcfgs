{ config, pkgs, ... }:
let
  cursor = config.home.pointerCursor;
in
{
  # Posy's base size is 32, where most themes' is 24. niri loads a cursor at
  # the scale rounded up, 2 on fw16's 1.25, and draws it down from there; the
  # variants drawn for 125% and 175% are never asked for.
  home.pointerCursor = {
    enable = true;
    package = pkgs.posy-cursors;
    name = "Posy_Cursor";
    size = 32;
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
