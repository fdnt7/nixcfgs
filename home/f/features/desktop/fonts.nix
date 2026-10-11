{ pkgs, ... }:
{
  fonts.fontconfig = {
    enable = true;
    # Programs ask for "monospace" and get this, so the family is named once.
    defaultFonts.monospace = [ "JetBrainsMono Nerd Font" ];
  };

  home.packages = [ pkgs.nerd-fonts.jetbrains-mono ];
}
