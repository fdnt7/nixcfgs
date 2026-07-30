{
  imports = [
    ./libvirt-lan-sharing.nix
    ./tailscale-split-tunnel.nix
  ];

  services.mullvad-vpn = {
    enable = true;
    gui.enable = true;
  };

  persist.mullvad-vpn = true;
}
