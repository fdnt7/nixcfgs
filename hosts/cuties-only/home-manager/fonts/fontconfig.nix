{pkgs, ...}: {
  home.packages = with pkgs; [noto-fonts];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = ["Noto Serif" "Noto Serif Thai"];
      sansSerif = ["Noto Sans" "Noto Sans Thai"];
    };
  };
}
