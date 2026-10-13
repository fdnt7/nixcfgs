{
  # Resource monitor. Without its own background, the terminal's shows.
  programs = {
    btop = {
      enable = true;
      settings.theme_background = false;
    };
    fish.shellAbbrs.bt = "btop";
  };
}
