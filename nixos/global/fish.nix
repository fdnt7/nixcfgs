{
  # System-side support for fish as a login shell: it is registered in
  # /etc/shells, gets the system environment, and picks up completions that
  # packages ship. Each user's own settings live in Home Manager.
  programs.fish.enable = true;
}
