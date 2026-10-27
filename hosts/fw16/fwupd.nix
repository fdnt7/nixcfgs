{
  # fwupd, which nixos-hardware turns on, probes the Audio Expansion Card's
  # DSP for its firmware version whenever it starts (the daily metadata
  # refresh starts it) and when the card is plugged in. On fwupd 2.1.6 and
  # Linux 7.2.9 the card sometimes stopped answering mid-probe and then
  # stayed dead, without sound, until it was unplugged or the machine was
  # powered off; a reboot did not reset it. Seen five times 2026-10-12 to
  # -16: "failed to get firmware version info: ... USB error: Operation
  # timed out". Reported: https://github.com/fwupd/fwupd/issues/11260.
  #
  # It was worked around with DisabledPlugins = [ "synaptics_cape" ]. On
  # fwupd 2.1.8 and Linux 7.3.0, 30 daemon restarts and two direct probes
  # were clean, so the plugin is back on trial from 2026-10-27, in everyday
  # use (hotplugs, suspends, refreshes). If the card goes silent, leave it
  # in, report the journal on the issue, then pull it to recover; put the
  # setting back if it fails again. If it stays clean until 2026-11-10, say
  # so on the issue and delete this file.
}
