{ inputs, ... }:
{
  imports = [ inputs.self.nixosModules.mullvad-libvirt-lan-sharing ];

  services.mullvad-libvirt-lan-sharing.enable = true;
}
