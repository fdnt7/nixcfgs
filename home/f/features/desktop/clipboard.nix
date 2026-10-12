{ pkgs, ... }:
{
  # On Wayland a copy lives in the program it came from. wl-clip-persist
  # keeps it after that program closes. The history is the shell's, opened
  # with a bind in ./niri.nix.
  services.wl-clip-persist.enable = true;

  # `wl-copy` and `wl-paste`, for scripts.
  home.packages = [ pkgs.wl-clipboard ];
}
