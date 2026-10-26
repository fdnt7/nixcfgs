{ pkgs, ... }:
{
  # On Wayland a copy lives in the program it came from. The shell keeps it
  # after that program closes, and keeps the history, opened with a bind in
  # ./niri.kdl. This adds `wl-copy` and `wl-paste`, for scripts.
  home.packages = [ pkgs.wl-clipboard ];
}
