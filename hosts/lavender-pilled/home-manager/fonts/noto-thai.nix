{pkgs, ...}: {
  home.packages = [pkgs.noto-fonts];

  fonts.fontconfig = {
    defaultFonts = {
      serif = ["Noto Serif" "Noto Serif Thai"];
      sansSerif = ["Noto Sans" "Noto Sans Thai"];
    };
  };
}
