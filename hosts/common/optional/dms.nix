{
  # DankMaterialShell: bar, launcher, notifications, lock screen and idle
  # handling in one shell, started as a user service with the session. Its
  # settings are kept by the shell itself, in ~/.config/DankMaterialShell.
  #
  # The lock screen needs no PAM service here: on NixOS the shell derives a
  # password-only stack from `login` into its state directory, and reads the
  # fingerprint reader through a second stack shipped in its package.
  programs.dms-shell.enable = true;

  # Battery state over D-Bus, for the shell's battery widget.
  services.upower.enable = true;
}
