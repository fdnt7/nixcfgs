{ pkgs, ... }:
let
  nerdFontsJetbrainsMonoFamily = "JetBrainsMono Nerd Font";
in
{
  home.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  fonts.fontconfig.defaultFonts.monospace = [ nerdFontsJetbrainsMonoFamily ];

  programs.foot.settings.main.font = "${nerdFontsJetbrainsMonoFamily}:size=11";
}
