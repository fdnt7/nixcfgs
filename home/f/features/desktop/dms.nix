{
  # Settings for Dux Shell (formerly DankMaterialShell, and still `dms` on
  # the command line), which is enabled system-wide:
  # ../../../../nixos/optional/dms.nix. The file is read-only to
  # the shell, so a change made in its settings window lasts until the
  # shell restarts; make it here to keep it.
  #
  # Not here, because the shell keeps them with its state instead, in
  # ~/.local/state/dms: the weather location, and where each lock screen
  # widget sits, which is set by dragging it in the lock screen's editor.
  xdg.configFile."dms/settings.json" = {
    # The shell writes its own copy when it first starts.
    force = true;
    text = builtins.toJSON {
      # The format version. A lower one is migrated at every start and the
      # result never saved, the file being read-only, so this stays at the
      # shell's own: 42 for 2.0.
      configVersion = 42;

      clockFormat = "24h";
      # How rounded corners are, replacing a radius in pixels; 38 is what
      # the 12 pixels this used to say come to.
      radiusStrength = 38;
      networkPreference = "wifi";
      osdPowerProfileEnabled = true;

      # The shell writes a niri rule floating its own windows, once per
      # compositor, and notes here that it has; noted already, it does not
      # try again at every start. ./niri.kdl does not include the files the
      # shell writes for niri, so the rule itself does nothing.
      dmsWindowsFloatingSeeded = [ "niri" ];

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
            {
              id = "controlCenterButton"; # ignore "center" # spellchecker:disable-line
              enabled = true;
              showMicPercent = true;
            }
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
          followInterfaceStyle = true;
          widgetFollowInterfaceStyle = true;
          squareCorners = false;
          noBackground = false;
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
          scrollXBehavior = "focusWindow";
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
