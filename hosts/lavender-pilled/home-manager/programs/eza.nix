{
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    git = true;
    icons = "always";

    extraOptions = [
      "-lah"
      "--group-directories-first"
      "--colour-scale"
    ];
  };

  programs.eza.colors = "always";
}
