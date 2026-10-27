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

  # At login, once the sound server can take an audio device. The target
  # is named so that the session does not wait for this: left out,
  # systemd orders the unit before it.
  #
  # Not after waking: BlueZ reconnects the audio devices a suspend
  # dropped by itself, two seconds after resume (ResumeDelay in
  # main.conf). A unit that did it too only raced BlueZ, and as a oneshot
  # it held up shutdowns on fw16 and a reboot on fw12.
  #
  # Started by exec rather than as a oneshot, as nothing waits for it to
  # finish: a oneshot's start job stays queued until the script ends,
  # and systemd refuses to stop it for a reboot or power-off.
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
}
