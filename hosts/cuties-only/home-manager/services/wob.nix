{
  services.wob = {
    enable = true;
    settings = {
      "" = {
        max = 100;
        timeout = 500;
        anchor = "bottom right";
        width = 1920;
        height = 2;
        border_size = 0;
        border_offset = 0;
        bar_padding = 0;
        background_color = "00000088";
        overflow_bar_color = "FF8800";
      };
      "style.red".bar_color = "FF0000";
    };
  };

  wayland.windowManager.hyprland.settings.layerrule = ["noanim, wob"];
}
