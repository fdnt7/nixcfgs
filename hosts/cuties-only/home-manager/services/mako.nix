{
  services.mako = {
    enable = true;
    settings = {
      anchor = "bottom-right";
      outer-margin = "0,0,24,0";
      max-icon-size = 32;
      font = "JetBrainsMono Nerd Font 9";
      border-size = 1;

      "urgency=low" = {
        background-color = "#1e1e1eAA";
        border-color = "#444444ff";
        default-timeout = 5000;
      };

      "urgency=normal" = {
        background-color = "#1E1E2EAA";
        border-color = "#a6a6ff";
        default-timeout = 10000;
      };

      "urgency=critical" = {
        border-color = "#ffa6a6FF";
        background-color = "#2e1e1eAA";
        default-timeout = 0;
      };
    };
  };

  wayland.windowManager.hyprland.settings.layerrule = [
    "blur, notifications"
    "ignorezero, notifications"
  ];
}
