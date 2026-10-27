{
  config,
  inputs,
  pkgs,
  ...
}:
let
  hostKey = "${config.impermanence.persist}/etc/ssh/ssh_host_ed25519_key";
  keyFile = "${config.impermanence.persist}/var/lib/sops-nix/key.txt";
in
{
  # Secrets kept encrypted in the repository and decrypted at boot into
  # /run/secrets. The host decrypts with an age key of its own, made on
  # the host the first time this is activated, and read straight from the
  # persistent volume. Its own rather than the SSH host key, so that the
  # secrets do not hang on a key an SSH server would hold.
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    age = {
      inherit keyFile;
      generateKey = true;
      # Until the files are encrypted for the key above as well.
      sshKeyPaths = [ hostKey ];
    };
    gnupg.sshKeyPaths = [ ];
  };

  # For editing on the host itself:
  #   sudo SOPS_AGE_KEY_FILE=<key file> sops edit <file>
  # and for the key's recipient, to put in .sops.yaml:
  #   sudo age-keygen -y <key file>
  environment.systemPackages = [
    pkgs.age
    pkgs.sops
  ];
}
