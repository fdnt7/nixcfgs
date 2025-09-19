{pkgs}:
pkgs.writeShellScript "vol" ''
  # Get volume level and mute status
  volume=$(echo "$(vol src)*100/1" | bc)
  muted=$(vol src -m)

  # Check if muted
  if [ "$muted" = "1" ]; then
      b="󰍮  - %"
  else
      # Choose icon based on volume level
      if [ "$volume" -eq 0 ]; then
          icon="󰍭"
      else
          icon="󰍬"
      fi

      b="$icon $(printf '%4s' "$volume%")"
  fi

  # Get volume level and mute status
  volume=$(echo "$(vol sink)*100/1" | bc)
  muted=$(vol sink -m)

  # Check if muted
  if [ "$muted" = "1" ]; then
      c="󰝟  - %"
  else
      # Choose icon based on volume level
      if [ "$volume" -eq 0 ]; then
          icon="󰸈"
      elif [ "$volume" -le 33 ]; then
          icon="󰕿"
      elif [ "$volume" -le 66 ]; then
          icon="󰖀"
      else
          icon="󰕾"
      fi

      c="$icon $(printf '%4s' "$volume%")"
  fi

  echo "$b $c"
''
