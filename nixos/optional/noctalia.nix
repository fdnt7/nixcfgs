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

    # Two fixes to the lock screen's fingerprint reader, built here until
    # Noctalia ships them; drop each once it does.
    package = pkgs.noctalia.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [
        # Right after resume, before logind has made the session active again,
        # fprintd refuses to verify, and the lock screen gave up on the finger
        # for that lock. This retries the refusal for up to five seconds.
        # Upstream's own pull request, as it stands, without its test.
        (pkgs.fetchpatch {
          name = "noctalia-retry-fingerprint-authorisation.patch";
          url = "https://github.com/noctalia-dev/noctalia/compare/8fd4399e38704afdb3b34963637b5fd86c52e4f4...9cabc9ae045d03557977bd88f3a76708cac8e6c6.diff";
          includes = [ "src/*" ];
          hash = "sha256-s7ukWiCOOJO3IfZkGaStQ1cul3mxm/+Fk6+hKHxD8Kk=";
        })
        # After a match, the lock screen waited on fprintd to stop the reader,
        # a second or more on fw16, before it began to unlock; this leaves the
        # reader to stop in the background. Upstream's fix is larger and not
        # yet merged: https://github.com/noctalia-dev/noctalia/pull/4922.
        ./noctalia-async-fingerprint-release.patch
      ];
    });
  };

  # The lock screen checks a password against the `login` stack, where
  # pam_fprintd comes first and waits about 30 seconds for a finger before
  # the password is looked at. Noctalia reads the sensor itself, so the
  # stack goes without it; only a login on the console loses the finger.
  # Upstream: https://github.com/noctalia-dev/noctalia/issues/3277.
  security.pam.services.login.fprintAuth = false;
}
