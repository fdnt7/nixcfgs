{ nixcfgs, ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  services.blueman.enable = true;

  environment.persistence.${nixcfgs.persist}.directories = [ "/var/lib/bluetooth" ];
}
