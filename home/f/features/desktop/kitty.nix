{
  # The terminal, chosen on 2026-10-26 over foot and Ghostty: with
  # --single-instance, kitty's launcher hands the command line to the
  # running instance in C, before any Python starts, so a window opens as
  # fast as footclient's; and the shell recolours it when its theme
  # changes, which it does not do for foot. Ghostty opened its windows a
  # beat later than either.
  programs.kitty = {
    enable = true;
    settings = {
      # The family comes from ./fonts.nix.
      font_family = "monospace";
      font_size = 9;
    };
    # The colours the shell writes, and tells kitty to reload when they
    # change. Until the shell next makes its colours the file isn't there,
    # which kitty logs and passes over.
    extraConfig = "include dank-theme.conf";
  };
}
