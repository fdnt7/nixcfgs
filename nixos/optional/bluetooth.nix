{ config, ... }:
{
  hardware.bluetooth.enable = true;

  environment.persistence.${config.impermanence.persist}.directories = [ "/var/lib/bluetooth" ];

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
