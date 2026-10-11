{
  imports = [
    ./global
    ./features/cli
    ./features/desktop
  ];

  # The built-in 2560x1600 panel.
  wayland.windowManager.niri.extraConfig = ''
    output "eDP-1" {
        scale 1.25
    }
  '';
}
