{
  # Started by niri's default config (`spawn-at-startup "waybar"`), so no
  # systemd unit here.
  programs.waybar = {
    enable = true;
    settings.mainBar = {
      position = "bottom";
      modules-left = [ "niri/workspaces" ];
      modules-center = [ "niri/window" ]; # spellchecker:disable-line
      modules-right = [
        "tray"
        "network"
        "wireplumber"
        "battery"
        "clock"
      ];
    };
  };
}
