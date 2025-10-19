{ pkgs, ... }:
{
  home.packages = [ pkgs.brave ];

  wayland.windowManager.hyprland.settings.windowrulev2 = [
    "workspace 1, class:^(brave-browser(-nightly)?)$"
  ];
}
