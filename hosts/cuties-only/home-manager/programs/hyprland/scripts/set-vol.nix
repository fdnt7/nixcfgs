{ pkgs }:
let
  bc = "${pkgs.bc}/bin/bc";
  VOL = import ../../../scripts/vol.nix { inherit pkgs; };
in
pkgs.writeShellScript "set-vol" ''
  # Check if both arguments are provided
  if [[ $# -ne 2 ]]; then
      echo "Usage: $0 <sink|src> <u|d>"
      echo "  sink|src: Device type (sink or source)"
      echo "  u|d: Direction (u for up/+, d for down/-)"
      exit 1
  fi

  DEVICE_TYPE="$1"
  DIRECTION="$2"

  # Validate device type
  if [[ "$DEVICE_TYPE" != "sink" && "$DEVICE_TYPE" != "src" ]]; then
      echo "Error: Device type must be 'sink' or 'src'"
      echo "Usage: $0 <sink|src> <u|d>"
      exit 1
  fi

  # Validate direction
  if [[ "$DIRECTION" != "u" && "$DIRECTION" != "d" ]]; then
      echo "Error: Direction must be 'u' (up) or 'd' (down)"
      echo "Usage: $0 <sink|src> <u|d>"
      exit 1
  fi

  # Set the appropriate device based on argument
  if [[ "$DEVICE_TYPE" == "sink" ]]; then
      DEVICE="@DEFAULT_AUDIO_SINK@"
  elif [[ "$DEVICE_TYPE" == "src" ]]; then
      DEVICE="@DEFAULT_AUDIO_SOURCE@"
  fi

  # Set the volume change based on direction
  if [[ "$DIRECTION" == "u" ]]; then
      VOLUME_CHANGE="5%+"
  elif [[ "$DIRECTION" == "d" ]]; then
      VOLUME_CHANGE="5%-"
  fi

  # Set volume and send to wob
  wpctl set-volume "$DEVICE" "$VOLUME_CHANGE" &&
  echo "$(${VOL} "$DEVICE_TYPE")*100/1" | ${bc} > "$XDG_RUNTIME_DIR/wob.sock"
''
