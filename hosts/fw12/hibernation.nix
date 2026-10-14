{
  # Hibernate to the swap file inside the encrypted volume. The offset is
  # from `btrfs inspect-internal map-swapfile -r /swap/swapfile` and changes
  # if the swap file is recreated.
  #
  # WATCH (2026-10-14): resume worked on the first try, but this machine
  # may share fw16's problem (see ../fw16/hibernation.nix): the kernel
  # refuses an image when the firmware memory map differs from the one it
  # was written under, and the TPM event log's address in that map moved
  # between this machine's first boots (0x44a08018, 0x44a0b018, then
  # 0x44a07018 twice since Secure Boot was turned on). To check, compare
  # across a few boots:
  #   journalctl -k -b <n> | grep -o 'TPMEventLog=0x[0-9a-f]*'
  # If it stays put, drop this note.
  boot.resumeDevice = "/dev/mapper/enc";
  boot.kernelParams = [ "resume_offset=533760" ];
}
