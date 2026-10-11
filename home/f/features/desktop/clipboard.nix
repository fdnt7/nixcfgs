{ pkgs, ... }:
{
  # On Wayland a copy lives in the program it came from. wl-clip-persist
  # keeps it after that program closes; cliphist records a history, opened
  # with a bind in ./niri.nix.
  services.wl-clip-persist.enable = true;
  services.cliphist.enable = true;

  # `wl-copy` and `wl-paste`, for scripts and the history picker.
  home.packages = [ pkgs.wl-clipboard ];
}
