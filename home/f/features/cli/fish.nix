{
  # The login shell, set in ../../../../hosts/common/users/f.nix.
  programs.fish = {
    enable = true;
    shellInit = "set -g fish_greeting";
  };

  # The fish module turns on a `man -k` index of the user's packages, which
  # man-db can only be pointed at through ~/.manpath.
  programs.man.generateCaches = false;
}
