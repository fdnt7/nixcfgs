{ pkgs, ... }:
{
  # Dux Shell, formerly DankMaterialShell: bar, launcher, notifications, lock
  # screen and idle handling in one shell, started as a user service with the
  # session. Its command and service are still `dms`. Its settings are per
  # user: ../../home/f/features/desktop/dms.nix.
  #
  # The lock screen needs no PAM service here: on NixOS the shell derives a
  # password-only stack from `login` into its state directory, and reads the
  # fingerprint reader through a second stack shipped in its package.
  programs.dux-shell = {
    enable = true;
    # The wallpaper fades in at login: the shell gives every later change a
    # transition, but showed the first one at once. Built here, as the shell
    # is one binary with its interface inside.
    package = pkgs.dux-shell.overrideAttrs {
      patches = [ ./dux-wallpaper-startup-fade.patch ];
      # The build runs from core/, beside the interface the patch changes,
      # which is unpacked read-only.
      prePatch = "chmod -R u+w ../quickshell";
      patchFlags = [
        "-p1"
        "-d"
        ".."
      ];
    };
  };

  # Battery state over D-Bus, for the shell's battery widget.
  services.upower.enable = true;
}
