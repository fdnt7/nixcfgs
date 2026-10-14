# This machine's TPM has no NV memory left for another NvPCR counter index:
# TPM2_PT_NV_COUNTERS_AVAIL reports 0, and most of the NV region is factory
# EK certificate material that cannot be removed. systemd ships four
# NvPCRs; only two fit.
#
# systemd 261 added the 'login' NvPCR and systemd-pcrlogin@.service, which
# cannot create its index and so fails on every login. Upstream tolerates
# this condition for systemd-tpm2-setup.service but not for this unit, and
# offers no way to decline a single NvPCR.
#
# The drop-in tolerates any exit 1, since the unit cannot see why the tool
# failed; the tool still logs the reason. Nothing here consumes the 'login'
# NvPCR. Drop this file if NV space is ever reclaimed, or once systemd
# handles NV exhaustion on this path.
{
  systemd.units."systemd-pcrlogin@.service" = {
    overrideStrategy = "asDropin";
    text = ''
      [Service]
      SuccessExitStatus=1
    '';
  };
}
