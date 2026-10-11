{
  # Scrollable-tiling Wayland compositor. This registers the session and
  # sets up its portals; each user's configuration is in Home Manager.
  programs.niri.enable = true;

  # hyprlock reads the fingerprint reader itself, alongside the password
  # field, so its PAM stack must not also wait for a finger.
  security.pam.services.hyprlock.fprintAuth = false;
}
