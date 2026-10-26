{
  # fwupd, which nixos-hardware turns on, probes the Audio Expansion Card's
  # DSP for its firmware version whenever it starts (the daily metadata
  # refresh starts it) and when the card is plugged in. The card sometimes
  # stops answering mid-probe and then stays dead, without sound, until it
  # is unplugged or the machine is powered off; a reboot does not reset it,
  # and its retries at boot hold up the input modules on the same hub.
  # Seen 2026-10-12 and -16: "failed to get firmware version info: ...
  # USB error: Operation timed out". Reported:
  # https://github.com/fwupd/fwupd/issues/11260; drop this once it is
  # fixed.
  #
  # The plugin only covers this card's DSP and some Sennheiser/EPOS
  # headsets, so nothing else loses firmware updates. Firmware for the
  # card itself would have to be applied by hand.
  services.fwupd.daemonSettings.DisabledPlugins = [ "synaptics_cape" ];
}
