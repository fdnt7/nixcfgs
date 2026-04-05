{ inputs, ... }:
{
  imports = [ inputs.self.nixosModules.mullvad-tailscale-split-tunnel ];

  networking.nftables.enable = true;
  services.resolved.enable = true;

  services.mullvad-tailscale-split-tunnel.enable = true;
}
