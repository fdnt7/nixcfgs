let
  # How the wallpaper comes in at login, and the lock screen in and out: one
  # picked at random each time, quicker than the default 1.5 seconds. The
  # honeycomb is left out, as it dropped frames on fw16.
  transition = {
    transition = [
      "fade"
      "wipe"
      "disc"
      "stripes"
      "zoom"
    ];
    transition_duration = 800;
  };
in
{
  # Noctalia, on trial in place of Dux Shell (./dms.nix) from 2026-10-26,
  # mainly for its fade-in of the wallpaper at login. The package and the
  # system's side are in ../../../../nixos/optional/noctalia.nix.
  #
  # These are defaults: a change made in the settings window goes to
  # ~/.local/state/noctalia/settings.toml, which is read after this and
  # outlasts a restart. The weather location is set there.
  programs.noctalia = {
    enable = true;
    # Started with the session, and restarted when these settings change.
    systemd.enable = true;

    settings = {
      shell = {
        # Asks for a password when a program wants elevation, as Dux Shell
        # did.
        polkit_agent = true;
        # Everything it would ask is set here.
        setup_wizard_enabled = false;
        # Every animation half again as fast; the default felt sluggish next
        # to Dux Shell.
        animation.speed = 1.5;

        # One key per action in the power menu, as before: L lock, X log
        # out, S suspend, R reboot, P power off. Every action is listed, as
        # the list replaces the default one rather than adding to it.
        session.actions =
          map
            (action: {
              inherit (action) action shortcut;
              enabled = true;
              variant = action.variant or "default";
            })
            [
              {
                action = "lock";
                shortcut = "l";
              }
              {
                action = "logout";
                shortcut = "x";
              }
              {
                action = "lock_and_suspend";
                shortcut = "s";
              }
              {
                action = "reboot";
                shortcut = "r";
              }
              {
                action = "shutdown";
                shortcut = "p";
                variant = "destructive";
              }
            ];
      };

      # At the bottom, shown while the workspace is empty and hidden while
      # it has windows, as Dux Shell's was; the edge brings it back. No gap
      # is kept for it, so windows use the whole screen.
      bar = {
        order = [ "default" ];
        default = {
          position = "bottom";
          smart_auto_hide = true;
          reserve_space = false;
          # Edge to edge, rather than 100 pixels in from each end.
          margin_ends = 0;

          # Status on the right, ending in the clock; the middle is left to
          # what comes and goes.
          start = [
            "launcher"
            "workspaces"
            "active_window"
          ];
          center = [ "media" ]; # ignore "center" # spellchecker:disable-line
          end = [
            "tray"
            "clipboard"
            "weather"
            "cpu"
            "ram"
            "notifications"
            "battery"
            "control-center" # ignore "center" # spellchecker:disable-line
            "clock"
          ];
        };
      };

      # Clear of the bar, which they would otherwise cover: its 34 pixels and
      # a gap. The bar is not taken into account by itself.
      notification = {
        position = "bottom_right";
        offset_y = 42;
      };

      # Lock after five minutes idle, then the screen off 30 seconds into
      # the lock, however it was locked; suspend after half an hour.
      # Times are in seconds.
      # spellchecker:off
      # ignore "behavior": the shell's own key
      idle = {
        behavior_order = [
          "lock"
          "screen-off"
          "lock-and-suspend"
        ];
        behavior = {
          lock = {
            action = "lock";
            enabled = true;
            timeout = 300;
          };
          screen-off = {
            action = "screen_off";
            enabled = true;
            timeout = 330;
            locked_timeout = 30;
          };
          lock-and-suspend = {
            action = "lock_and_suspend";
            enabled = true;
            timeout = 1800;
          };
        };
      };
      # spellchecker:on

      # The wallpaper comes in at login rather than appearing at once,
      # which is what this trial is for.
      wallpaper = transition // {
        transition_on_startup = true;
      };
      lockscreen = transition;

      # The colour scheme Qt programs follow, through ./qt-theme.nix.
      # Nothing else is themed for now.
      theme.templates = {
        builtin_ids = [ "kcolorscheme" ];
        enable_community_templates = false;
      };
    };
  };
}
