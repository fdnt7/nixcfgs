{pkgs, ...}: let
  nerdFontsJetbrainsMonoFamily = "JetBrainsMono Nerd Font";
in {
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  programs.foot.settings.main.font = "${nerdFontsJetbrainsMonoFamily}:size=11";
}
