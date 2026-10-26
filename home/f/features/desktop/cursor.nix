{ config, pkgs, ... }:
let
  cursor = config.home.pointerCursor;
in
{
  # niri asks for the size times the scale rounded up, 2 on fw16's 1.25,
  # takes the nearest image the theme has, 32, 48, 64 and so on, and shows
  # it as it is, so the size moves in steps. 24 gets the 48 pixel images,
  # drawn at 150%, which look a touch small; Posy's own base size of 32
  # gets the 64 pixel ones, drawn at 200%. The set drawn for 125% and 175%
  # has a step between, at 175%, but its hand and move cursors are the
  # white set's. Reported:
  # https://github.com/simtrami/posy-improved-cursor-linux/issues/19;
  # take Posy_Cursor_Black_125_175 once the fix is in nixpkgs, though the
  # project has had no commits since January 2025.
  home.pointerCursor = {
    enable = true;
    package = pkgs.posy-cursors;
    name = "Posy_Cursor_Black";
    size = 32;
    # For GTK 3 programs, which read it from their settings and from dconf
    # rather than asking the compositor for a cursor by name.
    gtk.enable = true;
    # The theme is linked into the XDG data directory as well, and every
    # program here finds it there or through XCURSOR_PATH, so the copy in
    # ~/.icons, kept for programs that look nowhere else, is only clutter.
    dotIcons.enable = false;
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
