{
  # GitHub's published host key (https://api.github.com/meta), so the first
  # connection needs no trust-on-first-use prompt.
  programs.ssh.knownHosts."github.com".publicKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
}
