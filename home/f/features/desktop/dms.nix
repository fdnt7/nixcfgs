{
  # Settings for DankMaterialShell, which is enabled system-wide:
  # ../../../../nixos/optional/dms.nix. The file is read-only to
  # the shell, so a change made in its settings window lasts until the
  # shell restarts; make it here to keep it.
  #
  # Not here, because the shell keeps them with its state instead: the
  # weather location, in ~/.local/state/DankMaterialShell.
  xdg.configFile."DankMaterialShell/settings.json" = {
    # The shell writes its own copy when it first starts.
    force = true;
    text = builtins.toJSON {
      # The format version: a lower one would be migrated, and written back.
      configVersion = 18;

      clockFormat = "24h";
      cornerRadius = 12;
      controlCenterShowMicPercent = true; # ignore "center" # spellchecker:disable-line
      networkPreference = "wifi";
      osdPowerProfileEnabled = true;

      # No wallpaper from the shell, on any screen: ./wallpaper.nix.
      screenPreferences.wallpaper = [ ];

      # The power profile follows the charger: performance (2) when plugged
      # in, balanced (1) on battery. As strings, as the shell stores them.
      acProfileName = "2";
      batteryProfileName = "1";

      # qtengine's settings are declared in ./qt-theme.nix; the shell would
      # otherwise keep writing its own copy over them.
      matugenTemplateQtengine = false;

      # How long a key is held in the power menu to confirm its action,
      # in seconds; the shortest the shell offers.
      powerActionHoldDuration = 0.25;

      # Notifications at the bottom right (3). Repeats are shown: by
      # default one identical to another from the last five seconds is
      # dropped, which swallows the touchpad toggle's when it is pressed
      # twice.
      notificationPopupPosition = 3;
      notificationDedupeEnabled = false;

      # Lock after five minutes idle, screen off 30 seconds later, suspend
      # after half an hour; the same on battery. Times are in seconds.
      enableFprint = true;
      lockBeforeSuspend = true;
      acLockTimeout = 300;
      acPostLockMonitorTimeout = 30;
      acSuspendTimeout = 1800;
      batteryLockTimeout = 300;
      batteryPostLockMonitorTimeout = 30;
      batterySuspendTimeout = 1800;

      # One bar, written out in full: an entry is not merged with the
      # shell's defaults. What differs from them is at the top.
      barConfigs = [
        {
          id = "default";
          name = "Main Bar";

          # At the bottom (1), hidden while a window covers it and shown
          # again when the pointer reaches the edge.
          position = 1;
          autoHide = true;
          autoHideDelay = 250;
          autoHideStrict = false;
          showOnWindowsOpen = true;

          # Status on the right, ending in the clock; the middle is left to
          # what comes and goes.
          leftWidgets = [
            "launcherButton"
            "workspaceSwitcher"
            "focusedWindow"
          ];
          centerWidgets = [ "music" ]; # ignore "center" # spellchecker:disable-line
          rightWidgets = [
            "systemTray"
            "clipboard"
            "weather"
            "cpuUsage"
            "memUsage"
            "notificationButton"
            "battery"
            "controlCenterButton" # ignore "center" # spellchecker:disable-line
            "clock"
          ];

          enabled = true;
          visible = true;
          screenPreferences = [ "all" ];
          showOnLastDisplay = true;
          spacing = 4;
          innerPadding = 4;
          barInsetPadding = -1;
          barLengthPadding = 0;
          bottomGap = 0;
          attachToScreenEdge = false;
          transparency = 1;
          widgetTransparency = 1;
          squareCorners = false;
          noBackground = false;
          removeWidgetPadding = false;
          widgetPadding = 8;
          gothCornersEnabled = false;
          gothCornerRadiusOverride = false;
          gothCornerRadiusValue = 12;
          borderEnabled = false;
          borderOpacity = 1;
          borderThickness = 1;
          widgetOutlineEnabled = false;
          widgetOutlineOpacity = 1;
          widgetOutlineThickness = 1;
          fontScale = 1;
          iconScale = 1;
          openOnOverview = false;
          popupGapsAuto = true;
          popupGapsManual = 4;
          useOverlayLayer = false;
          scrollEnabled = true;
          shadowIntensity = 0;
          shadowOpacity = 60;
          clickThrough = false;
          hoverPopouts = false;
          hoverPopoutDelay = 150;

          # spellchecker:off

          # ignore "color"
          batteryColorMode = "theme";
          borderColor = "surfaceText";
          shadowColorMode = "default";
          shadowCustomColor = "#000000";
          widgetOutlineColor = "primary";

          # ignore "behavior"
          scrollXBehavior = "column";
          scrollYBehavior = "workspace";

          # ignore "maximize"
          maximizeDetection = true;
          maximizeWidgetIcons = false;
          maximizeWidgetText = false;

          # spellchecker:on
        }
      ];
    };
  };
}
