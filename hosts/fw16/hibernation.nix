{
  # Hibernate to the swap file inside the encrypted volume. The offset is
  # from `btrfs inspect-internal map-swapfile -r /swap/swapfile` and changes
  # if the swap file is recreated.
  #
  # KNOWN ISSUE (2026-10-11): resume is unreliable on this machine. The image
  # is written, but on the way back the kernel may refuse it with "Hibernate
  # inconsistent memory map detected!" and cold boot instead, losing the
  # session. The kernel's copy of the TPM event log is allocated as ACPI
  # reclaim memory, so it appears in the firmware memory map, and on this
  # firmware (BIOS 04.01) its address changes between boots; the resume check
  # in arch/x86/power/hibernate.c needs the whole map to be identical.
  # https://community.frame.work/t/fw16-hibernation-fails-to-resume-firmware-presenting-different-memory-map-every-boot/83015
  #
  # Not fixed in Linux 7.2.9 or 7.3-rc6, nor by nixos-hardware. To check a
  # newer kernel or BIOS: boot a few times and compare the TPMEventLog=
  # address in `journalctl -k | grep 'efi: ACPI='`; if it stays put, or the
  # kernel no longer checksums non-RAM regions, drop this note. Known
  # workarounds, neither taken: hide the TPM in the BIOS (breaks ./tpm-unlock.nix),
  # or patch drivers/firmware/efi/libstub/tpm.c to allocate the log as
  # EFI_LOADER_DATA (a kernel rebuild on every update).
  boot.resumeDevice = "/dev/mapper/enc";
  boot.kernelParams = [ "resume_offset=533760" ];
}
