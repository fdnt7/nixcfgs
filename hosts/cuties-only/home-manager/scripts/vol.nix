{pkgs}:
pkgs.writeShellScript "vol" ''
  # Parse command line arguments
  MUTE_FLAG=0
  DEVICE_TYPE=""

  while [[ $# -gt 0 ]]; do
      case $1 in
          -m)
              MUTE_FLAG=1
              shift
              ;;
          sink|src)
              DEVICE_TYPE="$1"
              shift
              ;;
          *)
              echo "Usage: $0 [-m] <sink|src>"
              echo "  -m: Show mute state (0 for unmuted, 1 for muted)"
              echo "  sink: Query default audio sink"
              echo "  src: Query default audio source"
              exit 1
              ;;
      esac
  done

  # Check if device type is provided
  if [[ -z "$DEVICE_TYPE" ]]; then
      echo "Error: Device type (sink or src) is required"
      echo "Usage: $0 [-m] <sink|src>"
      exit 1
  fi

  # Set the appropriate device based on argument
  if [[ "$DEVICE_TYPE" == "sink" ]]; then
      DEVICE="@DEFAULT_AUDIO_SINK@"
  elif [[ "$DEVICE_TYPE" == "src" ]]; then
      DEVICE="@DEFAULT_AUDIO_SOURCE@"
  fi

  # Get volume information
  if [[ $MUTE_FLAG -eq 1 ]]; then
      # Extract mute state
      RESULT=$(wpctl get-volume "$DEVICE" |
          sed -nre 's/Volume: ([01]\.[0-9][0-9])( \[MUTED\])?/\2/p')

      # Map empty string to 0 and " [MUTED]" to 1
      if [[ -z "$RESULT" ]]; then
          echo "0"
      elif [[ "$RESULT" == " [MUTED]" ]]; then
          echo "1"
      fi
  else
      # Extract volume level
      VOL=$(wpctl get-volume "$DEVICE" |
          sed -nre 's/Volume: ([01]\.[0-9][0-9])( \[MUTED\])?/\1/p')
      echo "$VOL"
  fi
''
