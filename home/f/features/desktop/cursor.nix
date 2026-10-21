{ config, pkgs, ... }:
let
  cursor = config.home.pointerCursor;
in
{
  # niri asks for the size times the scale rounded up, 2 on fw16's 1.25,
  # takes the nearest image the theme has, 32, 48, 64 and so on, and shows
  # it as it is, so the size moves in steps. 24 gets the 48 pixel images,
  # which in this variant are drawn at 175% rather than 150%: a step
  # between the 150% ones, which look small, and the 200% ones that Posy's
  # own base size of 32 gets, which look large.
  home.pointerCursor = {
    enable = true;
    package = pkgs.posy-cursors;
    name = "Posy_Cursor_Black_125_175";
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
