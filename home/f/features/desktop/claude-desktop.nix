{ inputs, pkgs, ... }:
{
  # Claude Desktop, for Cowork. The FHS variant, as Cowork looks for QEMU,
  # the UEFI firmware and virtiofsd at Debian's paths and runs its work in
  # a KVM guest; the plain package starts, but reports Cowork's tools as
  # missing. The host needs nothing more: /dev/kvm and /dev/vhost-vsock
  # are open to every user, and opening the latter loads vhost_vsock.
  home.packages = [
    inputs.claude-desktop.packages.${pkgs.stdenv.hostPlatform.system}.claude-desktop-fhs
  ];
}
