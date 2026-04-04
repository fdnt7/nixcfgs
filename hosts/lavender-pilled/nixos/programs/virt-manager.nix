{ pkgs, ... }:
{
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  environment.systemPackages = [ pkgs.dnsmasq ];
  persist.libvirt = true;
}
