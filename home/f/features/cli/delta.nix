{
  # Pager for diffs, used by git: ./git.nix.
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
}
