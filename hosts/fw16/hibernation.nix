{
  # Hibernate to the swap file inside the encrypted volume. The offset is
  # from `btrfs inspect-internal map-swapfile -r /swap/swapfile` and changes
  # if the swap file is recreated.
  #
  # KNOWN ISSUES (last checked 2026-11-04 on Linux 7.3.1, BIOS 04.01): the
  # image is written, but resume does not complete. Two separate causes:
  #
  # 1. Memory map. The kernel refuses the image with "Hibernate inconsistent
  #    memory map detected!" and cold boots, losing the session, whenever
  #    the TPM event log moved between the hibernating and the resuming
  #    boot. The EFI stub asks the firmware to allocate the log (as ACPI
  #    reclaim memory, so it shows in the memory map) before it loads the
  #    initrd, and the firmware's choice varies: either just below the
  #    initrd (0x642...) or higher up (0x69ef... to 0x69f0...). The
  #    resume check in arch/x86/power/hibernate.c needs the whole map to be
  #    identical. Since 2026-11-02 the low address has held on 7 of 8
  #    boots (0x642b8018 throughout 7.3.1), for no cause found: not the
  #    BIOS, bootloader, kernel, initrd or USB devices. It can revert on any
  #    boot.
  #    https://community.frame.work/t/fw16-hibernation-fails-to-resume-firmware-presenting-different-memory-map-every-boot/83015
  #
  # 2. Wi-Fi driver. With the memory map matching, the resumed kernel hangs:
  #    mt7925e's reset work (mt7925_mac_reset_work -> mt7925e_mac_reset ->
  #    napi_disable) oopses on a NULL pointer right after wiphy_resume
  #    starts, and wiphy_resume never returns, so userspace stays frozen
  #    (black screen, no network). amdgpu and nvidia restore fine. Found
  #    with pm_print_times=1, kernel.sysrq=1 and a forced crash (on
  #    Framework keyboards SysRq is a Fn chord, not Alt+SysRq+C) whose
  #    dmesg tail went to EFI pstore. No upstream report of this exact
  #    crash found; the mt76 tree has since gained a check of the
  #    drv_pmctrl return in mt7925e_mac_reset (not in 7.3), which may be
  #    related. Workaround not taken: unload mt7925e around sleep.
  #
  # To retest on a newer kernel or BIOS: compare the TPMEventLog= address
  # across boots in `journalctl -k | grep 'efi: ACPI='`; then hibernate
  # with the commands above and read the pstore dump. Drop this note once
  # resume works. Other workarounds for 1, neither taken: hide the TPM in
  # the BIOS (breaks ./tpm-unlock.nix), or patch
  # drivers/firmware/efi/libstub/tpm.c to allocate the log as
  # EFI_LOADER_DATA (a kernel rebuild on every update).
  boot.resumeDevice = "/dev/mapper/enc";
  boot.kernelParams = [ "resume_offset=533760" ];
}
