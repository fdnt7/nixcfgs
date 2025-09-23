{pkgs, ...}: {
  imports = [];

  home.packages = [pkgs.brightnessctl];

  wayland.windowManager.hyprland.settings.binde = let
    br = import ../programs/hyprland/scripts/br.nix {inherit pkgs;};
  in [
    ", xf86monbrightnessdown, exec, ${br} d" #fn+f7
    ", xf86monbrightnessup  , exec, ${br} u" #fn+f8
  ];
}
