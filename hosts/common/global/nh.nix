{
  # Weekly garbage collection as root, which is what can remove old system
  # generations. The `nh` command itself and the flake it defaults to are
  # each user's, in Home Manager.
  programs.nh.clean = {
    enable = true;
    # nh keeps only the current generation unless told otherwise.
    extraArgs = "--keep 5 --keep-since 7d";
  };
}
