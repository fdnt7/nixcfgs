{ pkgs }:
pkgs.writeShellScript "touchpad" ''
  STATUS_FILE="$XDG_RUNTIME_DIR/touchpad.status"

  if ! [ -f "$STATUS_FILE" ]; then
    STATUS="-"
  else
    if [ $(cat "$STATUS_FILE") = "true" ]; then
      STATUS="x"
    elif [ $(cat "$STATUS_FILE") = "false" ]; then
      STATUS="-"
    fi
  fi

  echo "󰟸 $STATUS"
''
