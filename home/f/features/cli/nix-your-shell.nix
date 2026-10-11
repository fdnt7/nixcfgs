{
  # Stay in fish inside `nix develop` and `nix-shell`, which otherwise drop
  # into bash.
  programs.nix-your-shell.enable = true;
}
