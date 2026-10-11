{
  # `ls` and friends. Icons wait for a Nerd Font to be installed.
  programs.eza = {
    enable = true;
    git = true;
    extraOptions = [
      "-lah"
      "--group-directories-first"
      # eza 0.23.5 removed `--colour-scale` by accident
      #
      # Refs: https://github.com/eza-community/eza/pull/1866
      # spellchecker:ignore-next-line
      "--color-scale=all"
    ];
  };

  programs.eza.colors = "always";
}
