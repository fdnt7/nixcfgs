{
  # Ask the TPM for the disk key first and fall back to the passphrase. The
  # key is enrolled out of band, bound to the Secure Boot state (PCR 7):
  #   systemd-cryptenroll --wipe-slot=tpm2 --tpm2-device=auto --tpm2-pcrs=7 \
  #     --tpm2-with-pin=true /dev/disk/by-uuid/9007b2bc-3c05-4d29-8f99-37b033afe129
  # Use the UUID path: the two NVMe drives swap names between boots. The slot
  # needs enrolling again whenever the Secure Boot state changes, such as
  # after a dbx update.
  boot.initrd.luks.devices."enc".crypttabExtraOpts = [ "tpm2-device=auto" ];
}
