{
  config,
  inputs,
  pkgs,
  ...
}:
let
  hostKey = "${config.impermanence.persist}/etc/ssh/ssh_host_ed25519_key";
in
{
  # Secrets kept encrypted in the repository and decrypted at boot into
  # /run/secrets. The host decrypts with its SSH host key, read straight
  # from the persistent volume, as the SSH server may not be enabled.
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    age.sshKeyPaths = [ hostKey ];
    gnupg.sshKeyPaths = [ ];
  };

  # For editing on the host itself, with the same key converted:
  #   sudo SOPS_AGE_KEY_CMD="ssh-to-age -private-key -i <host key>" \
  #     sops edit <file>
  # SOPS_AGE_SSH_PRIVATE_KEY_FILE does not do: it only matches recipients
  # written as SSH keys, and these are written as age keys.
  environment.systemPackages = [
    pkgs.sops
    pkgs.ssh-to-age
  ];
}
