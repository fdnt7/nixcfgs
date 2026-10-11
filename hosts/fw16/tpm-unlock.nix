{
  # Ask the TPM for the disk key first and fall back to the passphrase. The
  # key is enrolled out of band, bound to the Secure Boot state (PCR 7):
  #   systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 /dev/nvme1n1p2
  boot.initrd.luks.devices."enc".crypttabExtraOpts = [ "tpm2-device=auto" ];
}
