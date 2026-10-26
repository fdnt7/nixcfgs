{ inputs, ... }:
{
  # Plasma's settings, declared. Only what is set here is written; anything
  # else changed in System Settings stays as it is.
  imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

  programs.plasma = {
    enable = true;

    input = {
      # As on fw16, in ../../../f/features/desktop/niri.kdl: Caps Lock is
      # Escape, and Thai beside English, switched with Meta+Space below.
      keyboard = {
        repeatDelay = 200;
        repeatRate = 40;
        options = [ "caps:escape" ];
        layouts = [
          { layout = "us"; }
          { layout = "th"; }
        ];
      };

      # No pointer acceleration on external mice, as on fw16. Per device
      # too: the two that were used with this machine before.
      mice = [
        {
          name = "Logitech PRO X 2 DEX";
          vendorId = "046d";
          productId = "40b8";
          accelerationProfile = "none";
        }
        {
          name = "Logitech USB Receiver";
          vendorId = "046d";
          productId = "c54d";
          accelerationProfile = "none";
        }
      ];

      # Plasma keeps touchpad settings per device. Both touchpads this
      # machine has reported, from the settings of its previous install.
      touchpads = [
        {
          name = "PIXA3854:00 093A:0274 Touchpad";
          vendorId = "093A";
          productId = "0274";
          naturalScroll = true;
        }
        {
          name = "PIXA3854:00 093A:0239 Touchpad";
          vendorId = "093A";
          productId = "0239";
          naturalScroll = true;
        }
      ];
    };

    # The stock bottom panel, moving out of the way of windows that would
    # cover it, with a 24-hour clock.
    panels = [
      {
        location = "bottom";
        hiding = "dodgewindows";
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.pager"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          { digitalClock.time.format = "24h"; }
          "org.kde.plasma.showdesktop"
        ];
      }
    ];

    # As Mod+Return on fw16.
    hotkeys.commands.terminal = {
      name = "Open a terminal";
      key = "Meta+Return";
      command = "kitty --single-instance";
    };

    shortcuts = {
      # Meta+Space switches the keyboard layout and Meta+W closes a
      # window, as on fw16. Meta+W is the overview by default, which moves
      # to Meta+O, as on fw16 too.
      "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = "Meta+Space";
      kwin = {
        "Window Close" = [
          "Alt+F4"
          "Meta+W"
        ];
        Overview = "Meta+O";
      };
    };

    # The power profile follows the power source, as on fw16: everything
    # on the charger, the default on battery.
    powerdevil = {
      AC.powerProfile = "performance";
      battery.powerProfile = "balanced";
    };
  };
}
