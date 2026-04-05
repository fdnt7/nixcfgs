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

  # The stock libvirt 12.1 path uses systemd encrypted credentials for
  # /var/lib/libvirt/secrets/secrets-encryption-key. On this host that path
  # repeatedly boots into a stale state where the libvirt blob survives but the
  # matching systemd host key does not. Keep secret encryption enabled, but use
  # one persisted raw key owned by libvirt instead of the systemd credential
  # mechanism.
  environment.etc."libvirt/secret.conf".text = ''
    encrypt_data = 1
    secrets_encryption_key = "/var/lib/libvirt/secrets/secret-encryption-key"
  '';

  systemd.services.libvirtd = {
    after = [ "libvirt-secret-key-init.service" ];
    requires = [ "libvirt-secret-key-init.service" ];
    serviceConfig = {
      LoadCredentialEncrypted = lib.mkForce [ "" ];
      UnsetEnvironment = [ "SECRETS_ENCRYPTION_KEY" ];
    };
  };

  systemd.services.virtsecretd = {
    after = [ "libvirt-secret-key-init.service" ];
    requires = [ "libvirt-secret-key-init.service" ];
    serviceConfig = {
      LoadCredentialEncrypted = lib.mkForce [ "" ];
      UnsetEnvironment = [ "SECRETS_ENCRYPTION_KEY" ];
    };
  };

  systemd.services.virt-secret-init-encryption.serviceConfig = {
    ExecStart = lib.mkForce [
      ""
      "${pkgs.coreutils}/bin/true"
    ];
  };

  systemd.services.libvirt-secret-key-init = {
    description = "Initialize libvirt secret encryption key";
    before = [
      "libvirtd.service"
      "virtsecretd.service"
    ];
    after = [ "local-fs.target" ];
    wants = [ "local-fs.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      secret_key=/var/lib/libvirt/secrets/secret-encryption-key

      if [ ! -e "$secret_key" ]; then
        ${pkgs.coreutils}/bin/mkdir -p /var/lib/libvirt/secrets
        umask 0077
        ${pkgs.coreutils}/bin/dd if=/dev/urandom of="$secret_key" bs=32 count=1 status=none
      fi
    '';
  };
}
