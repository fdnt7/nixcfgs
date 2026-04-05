{ pkgs, ... }:
{
  imports = [
    ./libvirt-lan-sharing.nix
    ./tailscale-split-tunnel.nix
  ];

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  persist.mullvad-vpn = true;
}
