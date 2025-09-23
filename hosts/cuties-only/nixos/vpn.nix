{outputs, ...}: {
  imports = [outputs.nixosModules.mullvad-tailscale];
  services = {
    tailscale.enable = true;
    mullvad-vpn.enable = true;
    resolved.enable = true;
    mullvad-tailscale.enable = true;
  };

  networking.nftables.enable = true;
}
