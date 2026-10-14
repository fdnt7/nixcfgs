{ inputs, ... }:
{
  # Plasma's settings, declared. Only what is set here is written; anything
  # else changed in System Settings stays as it is.
  imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

  programs.plasma = {
    enable = true;

    input = {
      # As on fw16, in ../../../f/features/desktop/niri.kdl.
      keyboard = {
        repeatDelay = 200;
        repeatRate = 40;
      };

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
      command = "footclient";
    };
  };
}
