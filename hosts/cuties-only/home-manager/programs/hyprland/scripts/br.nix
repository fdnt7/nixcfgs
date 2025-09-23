{pkgs}: let
  bc = "${pkgs.bc}/bin/bc";
  BRIGHTNESSCTL = "${pkgs.brightnessctl}/bin/brightnessctl";
in
  pkgs.writeShellScript "br" ''
    # Number of brightness steps (easy to change)
    STEPS=20

    # Get current and max brightness
    current=$(${BRIGHTNESSCTL} get)
    max=$(${BRIGHTNESSCTL} max)

    # Function to calculate brightness value for a given step
    calc_brightness() {
        local step=$1
        echo $(( (step * max) / STEPS ))
    }

    # Function to find current step ordinal from current brightness
    find_current_step() {
        local best_step=0
        local min_diff=$max

        for step in $(seq 0 $STEPS); do
            local expected=$(calc_brightness $step)
            local diff=$(( current > expected ? current - expected : expected - current ))

            if [ $diff -lt $min_diff ]; then
                min_diff=$diff
                best_step=$step
            fi
        done

        echo $best_step
    }

    # Main logic
    case "$1" in
        "u"|"up")
            current_step=$(find_current_step)
            new_step=$(( current_step + 1 ))
            if [ $new_step -gt $STEPS ]; then
                new_step=$STEPS
            fi
            new_brightness=$(calc_brightness $new_step)
            ${BRIGHTNESSCTL} set $new_brightness
            echo "100*$new_step/$STEPS" | ${bc} > $XDG_RUNTIME_DIR/wob.sock
            #echo "Step $new_step/$STEPS: $new_brightness/$max"
            ;;
        "d"|"down")
            current_step=$(find_current_step)
            new_step=$(( current_step - 1 ))
            if [ $new_step -lt 0 ]; then
                new_step=0
            fi
            new_brightness=$(calc_brightness $new_step)
            ${BRIGHTNESSCTL} set $new_brightness
            echo "100*$new_step/$STEPS" | ${bc} > $XDG_RUNTIME_DIR/wob.sock
            #echo "Step $new_step/$STEPS: $new_brightness/$max"
            ;;
        "")
            current_step=$(find_current_step)
            echo "$current_step/$STEPS"
            ;;
        *)
            echo "Usage: $0 {u|up|d|down}"
            echo "Current: $(find_current_step)/$STEPS steps"
            exit 1
            ;;
    esac
  ''
