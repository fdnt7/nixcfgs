{
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    colors = "always";
    git = true;
    icons = "always";

    extraOptions = ["-lah" "--group-directories-first" "--colour-scale"];
  };
}
