{ inputs, ... }:
{
  imports = [
    inputs.zen-browser.homeModules.beta
    # or inputs.zen-browser.homeModules.twilight
    # or inputs.zen-browser.homeModules.twilight-official
  ];

  programs.zen-browser.enable = true;

  wayland.windowManager.hyprland.settings.windowrulev2 = [ "workspace 1, class:^(zen-beta)$" ];
}
