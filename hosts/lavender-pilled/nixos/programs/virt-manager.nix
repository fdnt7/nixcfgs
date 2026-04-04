{
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  networking.firewall.trustedInterfaces = [ "virbr0" ];
  persist.libvirt = true;
}
