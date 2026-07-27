{
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    git = true;
    icons = "always";

    extraOptions = [
      "-lah"
      "--group-directories-first"
      # eza 0.23.5 removed `--colour-scale` by accident
      #
      # Refs: https://github.com/eza-community/eza/pull/1866
      # spellchecker:ignore-next-line
      "--color-scale"
    ];
  };

  programs.eza.colors = "always";
}
