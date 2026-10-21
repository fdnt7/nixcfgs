{ config, ... }:
{
  environment.persistence.${config.impermanence.persist}.directories = [ "/var/db/sudo" ];
}
