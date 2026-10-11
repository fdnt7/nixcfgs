{ config, ... }:
{
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  environment.persistence.${config.impermanence.persist}.directories = [
    "/etc/NetworkManager/system-connections"
  ];
}
