{
  # `ls` and friends. The icons need a Nerd Font, which the desktop features
  # install.
  programs.eza = {
    enable = true;
    git = true;
    icons = "always";
    extraOptions = [
      "-lah"
      "--group-directories-first"
      # eza 0.23.5 removed `--colour-scale` by accident
      #
      # Refs: https://github.com/eza-community/eza/pull/1866
      "--color-scale=all"
    ];
  };

  programs.eza.colors = "always";
}
