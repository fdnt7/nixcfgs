{
  # On trial beside ./foot.nix, from 2026-10-26, after Ghostty opened its
  # windows a beat later than footclient: with --single-instance, kitty's
  # launcher hands the command line to the running instance in C, before any
  # Python starts, and the shell recolours it when its theme changes, which
  # it does not do for foot.
  #
  # The first `kitty --single-instance` of a session becomes the instance,
  # so only that first window waits on startup.
  programs.kitty = {
    enable = true;
    settings = {
      # The family comes from ./fonts.nix, at foot's size.
      font_family = "monospace";
      font_size = 9;
    };
    # The colours the shell writes, and tells kitty to reload when they
    # change. Until the shell next makes its colours the file isn't there,
    # which kitty logs and passes over.
    extraConfig = "include dank-theme.conf";
  };
}
