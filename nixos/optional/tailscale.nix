{ config, ... }:
{
  services.tailscale.enable = true;

  # The node key and login state.
  environment.persistence.${config.impermanence.persist}.directories = [ "/var/lib/tailscale" ];
}
