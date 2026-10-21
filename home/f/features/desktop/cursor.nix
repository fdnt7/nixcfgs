{ config, pkgs, ... }:
let
  cursor = config.home.pointerCursor;
in
{
  # niri asks for the size times the scale rounded up, 2 on fw16's 1.25,
  # takes the nearest image the theme has, 32, 48, 64 and so on, and shows
  # it as it is, so the size moves in steps. 24 gets the 48 pixel images,
  # drawn at 150%; Posy's own base size of 32 gets the 200% ones, which
  # look large. The set drawn for 125% and 175% has a step between, at
  # 175%, but its hand and move cursors are the white set's.
  #
  # TODO(upstream): report to
  # https://github.com/simtrami/posy-improved-cursor-linux/issues, then
  # link the issue here, and take Posy_Cursor_Black_125_175 once the fix
  # is in nixpkgs. Draft:
  #   Title: Posy_Cursor_Black_125_175: hand, link and move are the white
  #          set's
  #   Body: in Posy_Cursor_Black_125_175/cursors, `hand` and `move` are
  #   byte for byte the files in Posy_Cursor_125_175/cursors, and `link`
  #   is the same file as that `hand`, so the pointing hand, the open and
  #   closed hands, and the move cursor come up white with a black
  #   outline in the black set, at every size. Every other cursor in it
  #   is black. In Posy_Cursor_Black they are black, being
  #   Posy_Cursor's colours inverted, so it looks as if these three were
  #   copied over before inverting. Seen in 1.6 (the 1.6 tag, as
  #   packaged by nixpkgs) and still on master at ffef159.
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
