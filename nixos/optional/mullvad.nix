{ config, ... }:
{
  # The daemon runs as root and manages its own firewall rules, so this
  # cannot live in Home Manager. The graphical client comes with it.
  services.mullvad-vpn = {
    enable = true;
    gui.enable = true;
  };

  # The account, device key and settings, then the relay list.
  environment.persistence.${config.impermanence.persist}.directories = [
    "/etc/mullvad-vpn"
    "/var/cache/mullvad-vpn"
  ];
}
