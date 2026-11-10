{
  imports = [ ../../nixos/optional/openssh.nix ];

  # k, from fw12, with a key sealed by fw12's TPM, for work to run here:
  # as the account kept for it (./compute.nix), not as f.
  users.users.compute.openssh.authorizedKeys.keys = [
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBP/EDvDDNicsV7Dr+u+i3rloI0GO36LYxoJOfcflTB+CFsgrhLm105UavXP7EUR0R6eXkcyvdoxkvGoE+vymXl4= k@fw12"
  ];
}
