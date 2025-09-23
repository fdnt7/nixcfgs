{
  inputs,
  pkgs,
}: let
  HYPRCTL = "${inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland}/bin/hyprctl";
in
  pkgs.writeShellScript "toggle-touchpad" ''
    export STATUS_FILE="$XDG_RUNTIME_DIR/touchpad.status"

    enable_touchpad() {
      printf "true" >"$STATUS_FILE"
      echo 100 > $XDG_RUNTIME_DIR/wob.sock
      ${HYPRCTL} keyword '$LAPTOP_TOUCHPAD_ENABLED' "true" -r
    }

    disable_touchpad() {
      printf "false" >"$STATUS_FILE"
      echo 100 red > $XDG_RUNTIME_DIR/wob.sock
      ${HYPRCTL} keyword '$LAPTOP_TOUCHPAD_ENABLED' "false" -r
    }

    if ! [ -f "$STATUS_FILE" ]; then
      enable_touchpad
    else
      if [ $(cat "$STATUS_FILE") = "true" ]; then
        disable_touchpad
      elif [ $(cat "$STATUS_FILE") = "false" ]; then
        enable_touchpad
      fi
    fi
  ''
