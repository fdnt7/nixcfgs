# A Home Manager module to send notifications for low and critical battery levels.
#
# To use, import this file into your `home.nix` and enable the service:
#
# { config, pkgs, ... }:
# {
#   imports = [ ./battery-notifier.nix ];
#
#   services.battery-notifier.enable = true;
#
#   # Optional: customize thresholds and battery device
#   # services.battery-notifier.lowThreshold = 25;
#   # services.battery-notifier.criticalThreshold = 15;
#   # services.battery-notifier.batteryDevice = "BAT1";
# }
{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.services.battery-notifier;

  # This is the shell script that will be executed by the systemd service.
  # It checks the battery status and sends a notification if necessary.
  battery-check-script = pkgs.writeShellScript "battery-check" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    # --- Configuration ---
    BATTERY_PATH="/sys/class/power_supply/${cfg.batteryDevice}"
    LOW_THRESHOLD=${toString cfg.lowThreshold}
    CRITICAL_THRESHOLD=${toString cfg.criticalThreshold}

    # --- Pre-flight Checks ---
    # Exit if the battery device doesn't exist
    if [ ! -d "$BATTERY_PATH" ]; then
      echo "Battery device ${cfg.batteryDevice} not found at $BATTERY_PATH. Exiting."
      exit 0
    fi

    # Exit if not on battery power
    STATUS=$(cat "$BATTERY_PATH/status")
    if [ "$STATUS" != "Discharging" ]; then
      exit 0
    fi

    # --- Main Logic ---
    CAPACITY=$(cat "$BATTERY_PATH/capacity")

    # Path to a file to track the last notification level.
    # This prevents spamming notifications every minute.
    STATE_FILE="$XDG_RUNTIME_DIR/battery-notifier-state-''${UID:-$(id -u)}"

    # Read the last notified level, default to 100 if not set.
    LAST_NOTIFIED_LEVEL=$(cat "$STATE_FILE" 2>/dev/null || echo 100)

    # Function to send notification
    send_notification() {
      local URGENCY="$1"
      local TITLE="$2"
      local BODY="$3"
      # Use the user's DBUS session to send notifications
      export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
      ${pkgs.libnotify}/bin/notify-send -u "$URGENCY" "$TITLE" "$BODY"
      echo "$4" > "$STATE_FILE"
    }

    # --- Notification Logic ---
    # Critical notification
    if [ "$CAPACITY" -le "$CRITICAL_THRESHOLD" ] && [ "$LAST_NOTIFIED_LEVEL" -gt "$CRITICAL_THRESHOLD" ]; then
      send_notification "critical" "Battery Critical (''${CAPACITY}%)" "Plug in charger immediately!" "$CRITICAL_THRESHOLD"

    # Low notification
    elif [ "$CAPACITY" -le "$LOW_THRESHOLD" ] && [ "$LAST_NOTIFIED_LEVEL" -gt "$LOW_THRESHOLD" ]; then
      send_notification "normal" "Battery Low (''${CAPACITY}%)" "Consider plugging in your charger." "$LOW_THRESHOLD"

    # Reset state if battery is charged above the low threshold
    elif [ "$CAPACITY" -gt "$LOW_THRESHOLD" ]; then
      echo "100" > "$STATE_FILE"
    fi
  '';
in
{
  # --- Module Options ---
  # This section defines the configuration options that users can set.
  options.services.battery-notifier = {
    enable = mkEnableOption "battery notification service";

    lowThreshold = mkOption {
      type = types.int;
      default = 20;
      description = "The battery percentage to trigger a low battery notification.";
    };

    criticalThreshold = mkOption {
      type = types.int;
      default = 10;
      description = "The battery percentage to trigger a critical battery notification.";
    };

    batteryDevice = mkOption {
      type = types.str;
      default = "BAT0";
      description = "The name of the battery device in /sys/class/power_supply/.";
    };
  };

  # --- Module Implementation ---
  # This section defines the systemd services and timers based on the configuration.
  config = mkIf cfg.enable {
    systemd.user.services.battery-notifier = {
      Unit = {
        Description = "Periodic battery level check";
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${battery-check-script}";
        # Ensure PATH is set correctly for notify-send
        Environment = "PATH=/run/current-system/sw/bin";
      };
    };

    systemd.user.timers.battery-notifier = {
      Unit = {
        Description = "Timer to check battery level every minute";
      };
      Timer = {
        # Run 30 seconds after boot/login, and every minute thereafter.
        OnBootSec = "30s";
        OnUnitActiveSec = "1m";
        Unit = "battery-notifier.service";
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };
  };
}
