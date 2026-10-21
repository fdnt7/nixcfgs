{ config, inputs, ... }:
{
  imports = [ inputs.self.nixosModules.impermanence ];

  impermanence.enable = true;

  environment.persistence.${config.impermanence.persist} = {
    directories = [
      # impermanence recommends it
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };
}
