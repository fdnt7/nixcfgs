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

  # For editing on the host itself:
  #   sudo SOPS_AGE_SSH_PRIVATE_KEY_FILE=<host key> sops edit <file>
  environment.systemPackages = [ pkgs.sops ];
}
