{ config, ... }:
{
  hardware.bluetooth.enable = true;

  environment.persistence.${config.impermanence.persist}.directories = [ "/var/lib/bluetooth" ];
}
