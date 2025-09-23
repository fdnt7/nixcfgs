{pkgs}: let
  bc = "${pkgs.bc}/bin/bc";
  VOL = import ../../../scripts/vol.nix {inherit pkgs;};
in
  pkgs.writeShellScript "toggle-mute" ''
    DEVICE_TYPE="$1"

    # Validate device type
    if [[ "$DEVICE_TYPE" != "sink" && "$DEVICE_TYPE" != "src" ]]; then
        echo "Error: Device type must be 'sink' or 'src'"
        echo "Usage: $0 <sink|src>"
        exit 1
    fi

    # Set the appropriate device based on argument
    if [[ "$DEVICE_TYPE" == "sink" ]]; then
        DEVICE="@DEFAULT_AUDIO_SINK@"
    elif [[ "$DEVICE_TYPE" == "src" ]]; then
        DEVICE="@DEFAULT_AUDIO_SOURCE@"
    fi

    if [[ $(${VOL} $1 -m) == "0" ]]; then
      VOLUME="100 red"
    else
      VOLUME=$(echo $(${VOL} $1)*100/1 | ${bc})
    fi

    wpctl set-mute "$DEVICE" toggle
    echo $VOLUME > $XDG_RUNTIME_DIR/wob.sock
  ''
