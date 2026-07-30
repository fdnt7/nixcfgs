{ pkgs, ... }:
{
  imports = [
    ./libvirt-lan-sharing.nix
    ./tailscale-split-tunnel.nix
  ];

  services.mullvad-vpn = {
    enable = false;
    package = pkgs.mullvad-vpn;
  };

  persist.mullvad-vpn = true;
}
