{
  # Hibernate to the swap file inside the encrypted volume. The offset is
  # from `btrfs inspect-internal map-swapfile -r /swap/swapfile` and changes
  # if the swap file is recreated.
  boot.resumeDevice = "/dev/mapper/enc";
  boot.kernelParams = [ "resume_offset=533760" ];
}
