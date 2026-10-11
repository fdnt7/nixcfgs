{
  # Works on any compositor with the session-lock protocol, niri included.
  # The PAM side is in ../../../../hosts/common/optional/niri.nix.
  programs.hyprlock = {
    enable = true;
    settings = {
      general.hide_cursor = true;

      # Fingerprint and password are accepted side by side.
      auth.fingerprint.enabled = true;

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
        }
      ];

      label = [
        {
          text = "$TIME";
          font_size = 64;
          position = "0, 120";
          halign = "center"; # spellchecker:disable-line
          valign = "center"; # spellchecker:disable-line
        }
      ];

      input-field = [
        {
          size = "300, 50";
          position = "0, -40";
          halign = "center"; # spellchecker:disable-line
          valign = "center"; # spellchecker:disable-line
          placeholder_text = "Password or fingerprint";
        }
      ];
    };
  };
}
