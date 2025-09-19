{
  inputs,
  pkgs,
  lib,
  ...
}: {
  programs.waybar = {
    enable = true;
    settings = {
      main = let
        baseIcons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
        paddingIcon = " ";
        paddedBaseIcons = [paddingIcon] ++ baseIcons;
      in {
        mode = "overlay";
        start_hidden = true;
        position = "bottom";
        height = 24;
        spacing = 8;
        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];

        modules-center = [
          "hyprland/submap"
        ];

        modules-right = [
          "privacy"
          "tray"
          "custom/wttr"
          "hyprland/language"
          "custom/lock"
          "custom/touchpad"
          "temperature"
          "memory"
          "cpu"
          "backlight"
          "custom/vol"
          "battery"
          "clock"
        ];

        "custom/vol" = let
          VOL = "${import ./scripts/vol.nix {inherit pkgs;}}";
        in {
          format = "{}";
          exec = "${VOL}";
          interval = 2;
        };

        backlight = {
          format = "{icon}  {percent:>3}%";
          format-icons = ["󰃚" "󰃛" "󰃜" "󰃝" "󰃞" "󰃟" "󰃠"];
        };

        tray = {
          spacing = 2;
        };

        "custom/wttr" = {
          format = "{}";
          interval = 5400;
          exec = "echo $(curl \"wttr.in/Bangkok,TH?format=%c%t\" | tr -d '+CFK')";
        };

        "hyprland/workspaces" = let
          numericalIcons = builtins.listToAttrs (builtins.map (n: {
            name = builtins.toString n;
            value = builtins.toString n + " ";
          }) (builtins.genList (n: n + 1) 9)); # Generates a list [1, 2, ..., 9]
        in {
          format = "{icon}";
          format-icons =
            numericalIcons
            // {
              "10" = "0 ";
              "chat" = "󰌍 ";
              "music" = "= ";
              "minimised" = "- ";
              "scratch" = "` ";
            };
          show-special = true;
        };

        "hyprland/window" = {
          icon = true;
          icon-size = 18;
        };

        "hyprland/submap" = {
          format = "󰍍 {}";
        };

        "hyprland/language" = {
          format = "  {}";
          format-en = "us";
          format-th = "th";
        };

        network = {
          format = "{ifname}";
          #format-wifi = "{icon}  {bandwidthTotalBits:>}";
          format-wifi = "{icon}  {signalStrength:>}%";
          format-ethernet = "{icon}  {signalStrength}%";
          format-disconnected = "{icon} -";
          format-icons = {
            wifi = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
            linked = "󰄡";
            ethernet = ["󰣾" "󰣴" "󰣶" "󰣸" "󰣺"];
            disconnected = "";
          };
          tooltip-format = "{ifname} via {gwaddr}";
          tooltip-format-wifi = "{essid}  {bandwidthUpBits:>}  {bandwidthDownBits:>}";
          tooltip-format-ethernet = "{ifname}";
          tooltip-format-disconnected = "Disconnected";
          interval = 10;
          on-click = "nm-connection-editor";
        };

        battery = let
          FMT = "{icon} {capacity:>3}%";
        in {
          # power supply status reference:
          # https://www.kernel.org/doc/Documentation/ABI/testing/sysfs-class-power

          # because status "Not charging" seems to be unsupported, it
          # falls back to `format`, which is not wanted. ideally, it
          # should display as an empty string. so, the fallback
          # `format` is made as such also.
          format = "";
          format-unknown = "";
          format-charging = FMT;
          format-discharging = FMT;
          format-not-charging = "";
          format-full = "";
          format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          states = {
            warning = 20;
            critical = 10;
          };
        };

        temperature = let
          # Define your temperature thresholds
          startTemp = 35; # 🌡️ The temperature (C) at which the real icons should start
          criticalTemp = 95; # 🔥 The critical temperature (C)

          # Calculate the number of padding icons needed
          numPaddingIcons =
            builtins.ceil ((startTemp * (lib.lists.length baseIcons) * 1.0) / (criticalTemp - startTemp));

          # Generate the final list of icons
          finalIcons = (lib.lists.replicate numPaddingIcons paddingIcon) ++ baseIcons;
        in {
          format = "{icon} {temperatureC:>2}°";
          interval = 1;
          critical-threshold = criticalTemp;
          format-icons = finalIcons; # Use the dynamically generated list
        };

        memory = {
          format = "{icon} {percentage:>3}%";
          interval = 1;
          format-icons = paddedBaseIcons;
        };

        cpu = {
          format = "{icon} {usage:>3}%";
          interval = 1;
          format-icons = paddedBaseIcons;
        };

        # waybar's own keyboard state module is unresponsive; it
        # doesn't seem to be able to reliably update the
        # locked/unlocked states ...

        #keyboard-state = {
        #  numlock = true;
        #  capslock = true;
        #  scrolllock = true;
        #  format = {
        #    numlock = "󰞙 {icon} ";
        #    capslock = "󰘲 {icon} ";
        #    scrolllock = "󰞒 {icon} ";
        #  };
        #  format-icons = {
        #    locked = "x";
        #    unlocked = "-";
        #  };
        #};

        # ... so, using a custom-made one instead.

        "custom/lock" = let
          LOCK = "${import ./scripts/lock.nix {inherit pkgs;}}";
        in {
          format = "{}";
          exec = "${LOCK}";
          interval = 2;
        };

        "custom/touchpad" = let
          TOUCHPAD = "${import ./scripts/touchpad.nix {inherit pkgs;}}";
        in {
          format = "{}";
          exec = "${TOUCHPAD}";
          interval = 2;
        };

        clock = {
          format = "󰔚 {:%F %T}";
          interval = 1;
        };
      };
    };

    style = ./style.css;
    systemd.enable = true;
  };

  wayland.windowManager.hyprland.settings.bind = [
    # waybar gets out-of-sync between hidden/shown states very
    # often, so this remedies it as a reset bind.

    # `XF86Launch3` is the armoury crate button on the ASUS TUF Gaming A16 FA617NS
    ", XF86Launch3, exec, uwsm-app -- pkill -SIGUSR1 waybar"
  ];
}
