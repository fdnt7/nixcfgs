{ pkgs, ... }:
{
  # Noctalia, on trial in place of Dux Shell (./dms.nix): bar, launcher,
  # notifications, lock screen and idle handling in one shell. Its settings
  # and the service that starts it with the session are per user:
  # ../../home/f/features/desktop/noctalia.nix.
  #
  # The lock screen checks the password against the `login` PAM stack, and
  # asks fprintd for the fingerprint itself, over D-Bus.
  programs.noctalia = {
    enable = true;
    # NetworkManager, Bluetooth, UPower and power-profiles-daemon, for the
    # shell's widgets. Each is only a default; fw16 has all but UPower
    # already.
    recommendedServices.enable = true;

    # After a fingerprint matched, the lock screen waited on fprintd to stop
    # the reader, a second or more on fw16, before it began to unlock; this
    # leaves the reader to stop in the background. Drop it once upstream
    # does the same: https://github.com/noctalia-dev/noctalia/pull/4922.
    package = pkgs.noctalia.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [ ./noctalia-async-fingerprint-release.patch ];
    });
  };

  # The lock screen checks a password against the `login` stack, where
  # pam_fprintd comes first and waits about 30 seconds for a finger before
  # the password is looked at. Noctalia reads the sensor itself, so the
  # stack goes without it; only a login on the console loses the finger.
  # Upstream: https://github.com/noctalia-dev/noctalia/issues/3277.
  security.pam.services.login.fprintAuth = false;
}
