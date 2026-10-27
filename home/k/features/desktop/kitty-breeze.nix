{ lib, pkgs, ... }:
let
  themes = "${pkgs.kitty-themes}/share/kitty-themes/themes";
in
{
  # Breeze rather than f's Catppuccin, so the terminal matches the rest of
  # Plasma. Konsole's Breeze, as kitty ships it, is dark only; the light
  # one is ./kitty-breeze-light.conf. A theme of one's own cannot be named
  # in `autoThemeFiles`, which only looks in kitty-themes, so the files it
  # would write are written here instead. Plasma reports light or dark, so
  # no preference is only a fallback.
  programs.kitty.autoThemeFiles = lib.mkForce null;

  xdg.configFile = {
    "kitty/dark-theme.auto.conf".text = "include ${themes}/Konsole_Breeze_Dark.conf\n";
    "kitty/light-theme.auto.conf".text = "include ${./kitty-breeze-light.conf}\n";
    "kitty/no-preference-theme.auto.conf".text = "include ${./kitty-breeze-light.conf}\n";
  };
}
