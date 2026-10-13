{ config, pkgs, ... }:
let
  # niri cannot change an input device at run time, but it reloads its
  # config when an included file changes: ./niri.kdl includes this one.
  state = "${config.xdg.stateHome}/niri/touchpad.kdl";

  # A file, because no icon theme is set for the shell to look a name up in.
  icon = "${pkgs.kdePackages.breeze-icons}/share/icons/breeze-dark/devices/22/input-touchpad.svg";

  toggle-touchpad = pkgs.writeShellApplication {
    name = "toggle-touchpad";
    runtimeInputs = [ pkgs.libnotify ];
    text = ''
      # Shown briefly, silently and, being transient, kept out of the
      # history.
      notify() {
        notify-send --transient --expire-time 1500 \
          --hint boolean:suppress-sound:true \
          --app-name Touchpad --icon '${icon}' "$1"
      }

      mkdir -p "$(dirname '${state}')"

      # Empty or missing means on. The choice outlasts a reboot.
      if [ -s '${state}' ]; then
        : > '${state}'
        notify "Touchpad on"
      else
        echo 'input { touchpad { off; }; }' > '${state}'
        notify "Touchpad off"
      fi
    '';
  };
in
{
  home.packages = [ toggle-touchpad ];
}
