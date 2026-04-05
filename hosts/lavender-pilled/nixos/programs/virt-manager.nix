{
  lib,
  pkgs,
  ...
}:
{
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  networking.firewall.trustedInterfaces = [ "virbr0" ];
  persist.libvirt = true;

  # libvirt 12.1 generates /var/lib/libvirt/secrets/secrets-encryption-key
  # with `systemd-creds encrypt`. On this host, systemd's default auto key
  # selection is not stable across boots, so libvirtd eventually fails at the
  # CREDENTIALS step even though /var/lib/libvirt is persisted. Force the
  # persisted host key path instead of TPM/auto selection, and wait for both
  # persisted mounts before regenerating the libvirt key blob.
  systemd.services.virt-secret-init-encryption = {
    after = [
      "var-lib-systemd.mount"
      "var-lib-libvirt.mount"
    ];
    requires = [
      "var-lib-systemd.mount"
      "var-lib-libvirt.mount"
    ];
    serviceConfig.ExecStart = lib.mkForce [
      ""
      "${pkgs.bash}/bin/sh -c 'umask 0077 && (${pkgs.coreutils}/bin/dd if=/dev/random status=none bs=32 count=1 | ${pkgs.systemd}/bin/systemd-creds --with-key=host encrypt --name=secrets-encryption-key - /var/lib/libvirt/secrets/secrets-encryption-key)'"
    ];
  };
}
