{ outputs, ... }:
{
  imports = [ outputs.nixosModules.mullvad-tailscale ];

  # required
  networking.nftables.enable = true;
  services.tailscale.enable = true;

  # recommended
  services = {
    mullvad-vpn.enable = true;
    resolved.enable = true;
  };

  services.mullvad-tailscale.enable = true;

  persist = {
    tailscale = true;
    mullvad-vpn = true;
  };
}
