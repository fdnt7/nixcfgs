{ pkgs, ... }:
{
  virtualisation.libvirtd.enable = true;

  programs.virt-manager.enable = true;

  environment.systemPackages = [ pkgs.dnsmasq ];
  networking.firewall.trustedInterfaces = [ "virbr0" ];

  persist.libvirt = true;
}
