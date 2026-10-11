{
  # Wayland-only terminal. With the server running, `footclient` opens a
  # window in the existing process, which is near-instant.
  programs.foot = {
    enable = true;
    server.enable = true;
  };
}
