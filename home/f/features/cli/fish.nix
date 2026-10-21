{
  # The login shell, set in ../../../../nixos/users.
  programs.fish = {
    enable = true;
    shellInit = "set -g fish_greeting";
  };

  # The fish module turns on a `man -k` index of the user's packages, which
  # man-db can only be pointed at through ~/.manpath.
  programs.man.generateCaches = false;
}
