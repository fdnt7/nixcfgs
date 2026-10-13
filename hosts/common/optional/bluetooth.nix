{ config, pkgs, ... }:
let
  # Connects every trusted device that answers. Headphones and the like
  # only look for the machine when they are switched on, so one that was
  # already on when the machine came up stays unconnected until asked.
  reconnect = pkgs.writeShellApplication {
    name = "bluetooth-reconnect";
    runtimeInputs = [ config.hardware.bluetooth.package ];
    text = ''
      bluetoothctl devices Trusted | while read -r _ address _; do
        bluetoothctl connect "$address" || true
      done
    '';
  };
in
{
  hardware.bluetooth.enable = true;

  environment.persistence.${config.impermanence.persist}.directories = [ "/var/lib/bluetooth" ];

  # At login, once the sound server can take an audio device, and again
  # after waking from sleep. The target is named so that the session does
  # not wait for this: left out, systemd orders the unit before it.
  systemd.user.services.bluetooth-reconnect = {
    description = "Connect trusted Bluetooth devices";
    after = [
      "graphical-session.target"
      "wireplumber.service"
    ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${reconnect}/bin/bluetooth-reconnect";
    };
  };

  systemd.services.bluetooth-reconnect-resume = {
    description = "Connect trusted Bluetooth devices after sleep";
    after = [
      "suspend.target"
      "hibernate.target"
      "suspend-then-hibernate.target"
    ];
    wantedBy = [
      "suspend.target"
      "hibernate.target"
      "suspend-then-hibernate.target"
    ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${reconnect}/bin/bluetooth-reconnect";
    };
  };

  # Keep a Bluetooth audio output open while it is connected. By default
  # it is suspended after a few seconds of silence, and a short sound that
  # has to wake it, like a notification chime, comes out mangled.
  services.pipewire.wireplumber.extraConfig."51-bluez-no-suspend" = {
    "monitor.bluez.rules" = [
      {
        matches = [ { "node.name" = "~bluez_output.*"; } ];
        actions.update-props."session.suspend-timeout-seconds" = 0;
      }
    ];
  };
}
