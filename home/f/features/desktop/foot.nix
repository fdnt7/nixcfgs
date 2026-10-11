{
  # Wayland-only terminal. With the server running, `footclient` opens a
  # window in the existing process, which is near-instant.
  programs.foot = {
    enable = true;
    server.enable = true;
    # The family comes from ./fonts.nix.
    settings.main.font = "monospace:size=9";
  };
}
