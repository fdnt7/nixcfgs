{pkgs}: let
  bc = pkgs.bc.outPath;
  vol = import ../../../scripts/vol.nix {inherit pkgs;};
  volSrc = "${vol} src";
  volSink = "${vol} sink";
in
  pkgs.writeShellScript "vol" ''
    # Get volume level and mute status
    volume=$(echo "$(${volSrc})*100/1" | ${bc})
    muted=$(${volSrc} -m)

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
    volume=$(echo "$(${volSink})*100/1" | ${bc})
    muted=$(${volSink} -m)

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
