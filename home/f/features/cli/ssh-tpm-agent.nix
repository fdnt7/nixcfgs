{
  # SSH agent whose keys are sealed by this machine's TPM: they cannot be
  # copied off it and need no passphrase. Needs ../../../../hosts/common/optional/tpm.nix.
  # Create the key once with `ssh-tpm-keygen`, which writes
  # ~/.ssh/id_ecdsa.tpm and ~/.ssh/id_ecdsa.pub.
  services.ssh-tpm-agent.enable = true;
}
