{ pkgs, ... }:
{
  # Thai and East Asian text. Noto covers both; Sarabun is the typeface
  # Thai official documents are set in.
  home.packages = [
    pkgs.noto-fonts
    pkgs.noto-fonts-cjk-sans
    pkgs.sarabun-font
  ];

  fonts.fontconfig.defaultFonts = {
    serif = [
      "Noto Serif"
      "Noto Serif Thai"
    ];
    sansSerif = [
      "Noto Sans"
      "Noto Sans Thai"
    ];
  };
}
