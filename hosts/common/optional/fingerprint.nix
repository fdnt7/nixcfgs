{ config, ... }:
{
  services.fprintd.enable = true;

  environment.persistence.${config.impermanence.persist}.directories = [ "/var/lib/fprint" ];
}
