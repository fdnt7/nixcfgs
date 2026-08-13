# This machine's TPM has no NV memory left to allocate another NvPCR counter
# index: TPM2_PT_NV_COUNTERS_AVAIL reports 0, and roughly 4.3 KB of the ~6-7 KB
# NV region is factory-provisioned EK certificate material that cannot be
# removed. systemd ships four NvPCRs; only two fit, allocated back in April
# 2026 (0x01D10200 'hardware' and 0x01D10201 'cryptsetup').
#
# systemd 261 added the 'login' NvPCR plus systemd-pcrlogin@.service, which
# cannot create index 0x01D10203 and therefore fails on every login.
#
# Upstream tolerates this exact condition for systemd-tpm2-setup.service
# (SuccessExitStatus=CANTCREAT, and the tool logs "proceeding anyway") but not
# for systemd-pcrlogin@.service. Note --graceful does NOT cover this: it is
# documented as handling absence of a TPM2 device, not failure of a TPM2
# operation, and predates NvPCRs by six releases. There is also no supported way
# to decline an individual NvPCR -- systemd-pcrphase.service(8) documents only
# /usr/lib/nvpcr/*.nvpcr, with no /etc override and no masking convention.
#
# So this drop-in is a blunt local stand-in: SuccessExitStatus=1 tolerates *any*
# exit-1 failure, because the unit cannot see why pcrextend failed. Only the tool
# sees TPM_RC_NV_SPACE. Acceptable here because the unit does nothing else on
# this host.
#
# Nothing here consumes the 'login' NvPCR: no systemd-homed, no pcrlock policy,
# no TPM-bound LUKS keyslot. 'verity' has been unallocated since 2026-04-25
# with no observable effect.
#
# systemd-pcrextend still logs why it failed; only the unit-level failure is
# suppressed. Drop this file if NV space is ever reclaimed, or once systemd
# handles NV exhaustion on the --login path.
{
  systemd.units."systemd-pcrlogin@.service" = {
    overrideStrategy = "asDropin";
    text = ''
      [Service]
      SuccessExitStatus=1
    '';
  };
}
