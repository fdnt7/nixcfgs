{ pkgs }:
pkgs.writeShellScript "getleds" ''
  # Check if argument is provided
  if [ $# -eq 0 ]; then
      echo "Usage: $0 [n|c|s]"
      echo "  n - numlock"
      echo "  c - capslock"
      echo "  s - scrolllock"
      exit 1
  fi

  # Set the LED type based on argument
  case "$1" in
      n|numlock)
          led_type="numlock"
          ;;
      c|capslock)
          led_type="capslock"
          ;;
      s|scrolllock)
          led_type="scrolllock"
          ;;
      *)
          echo "Error: Invalid argument '$1'"
          echo "Usage: $0 [n|c|s]"
          echo "  n - numlock"
          echo "  c - capslock"
          echo "  s - scrolllock"
          exit 1
          ;;
  esac

  # Check if the LED path exists and read brightness
  led_path="/sys/class/leds/input0::''${led_type}/brightness"

  if [ -f "$led_path" ]; then
      cat "$led_path"
  else
      echo "Error: LED path not found: $led_path"
      exit 1
  fi
''
