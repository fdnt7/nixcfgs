{pkgs}: let
  GETLEDS = import ../../../scripts/getleds.nix {inherit pkgs;};
in
  pkgs.writeShellScript "showleds" ''
    # Capture both output and error from getleds

    if [ $# -eq 0 ]; then
      echo "Usage: $0 [n|c|s]"
      echo "  n - numlock"
      echo "  c - capslock"
      echo "  s - scrolllock"
      exit 1
    fi

    if ! VAL=$(${GETLEDS} "$1" 2>&1); then
        echo "Error from getleds: $VAL" >&2
        exit 1
    fi

    if [[ $VAL -eq 0 ]]; then
      WOB="100 red"
    else
      WOB="100"
    fi

    echo $WOB > $XDG_RUNTIME_DIR/wob.sock
  ''
