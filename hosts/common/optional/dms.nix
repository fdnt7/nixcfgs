{
  # DankMaterialShell: bar, launcher, notifications, lock screen and idle
  # handling in one shell, started as a user service with the session. Its
  # settings are kept by the shell itself, in ~/.config/DankMaterialShell.
  programs.dms-shell.enable = true;

  # Battery state over D-Bus, for the shell's battery widget.
  services.upower.enable = true;

  # The lock screen's password prompt. The shell reads the fingerprint
  # reader through a PAM stack of its own, alongside the password field, so
  # this one must not also wait for a finger.
  security.pam.services.dankshell.fprintAuth = false;
}
