{ config, pkgs, ... }:
let
  # Connects every trusted device that answers. Headphones and the like
  # only look for the machine when they are switched on, so one that was
  # already on when the machine came up stays unconnected until asked.
  #
  # Just after waking, bluetoothctl also prints the adapter's changes
  # ("[CHG] Controller ..."), so only the Device lines are read. A connect
  # to anything else never returns on its own, which once held up a
  # shutdown, hence the timeout and the closed input.
  reconnect = pkgs.writeShellApplication {
    name = "bluetooth-reconnect";
    runtimeInputs = [ config.hardware.bluetooth.package ];
    text = ''
      bluetoothctl devices Trusted | while read -r kind address _; do
        [ "$kind" = Device ] || continue
        bluetoothctl --timeout 15 connect "$address" </dev/null || true
      done
    '';
  };
in
{
  # For desktops without a Bluetooth daemon of their own. Plasma's
  # reconnects the devices that were connected, at login and after
  # resume, so a host on Plasma leaves this out: the two only race.
  imports = [ ./bluetooth.nix ];

  # At login, once the sound server can take an audio device, and again
  # after waking from sleep. The target is named so that the session does
  # not wait for this: left out, systemd orders the unit before it.
  #
  # Both are started by exec rather than as oneshots, as nothing waits
  # for them to finish: a oneshot's start job stays queued until the
  # script ends, and systemd refuses a reboot or power-off that would
  # have to stop it. Restarting just after waking on fw12, back when it
  # had this too, logged out and left a blank console instead of
  # rebooting.
  systemd.user.services.bluetooth-reconnect = {
    description = "Connect trusted Bluetooth devices";
    after = [
      "graphical-session.target"
      "wireplumber.service"
    ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "exec";
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
      Type = "exec";
      ExecStart = "${reconnect}/bin/bluetooth-reconnect";
    };
  };
}
