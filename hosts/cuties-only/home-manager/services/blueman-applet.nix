{
  services.blueman-applet.enable = true;

  wayland.windowManager.hyprland.settings.windowrulev2 = [
    "float, class:^(.blueman-manager-wrapped)$"
  ];
}
