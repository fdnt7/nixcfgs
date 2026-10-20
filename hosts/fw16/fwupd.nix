{
  # fwupd, which nixos-hardware turns on, probes the Audio Expansion Card's
  # DSP for its firmware version whenever it starts (the daily metadata
  # refresh starts it). The card sometimes stops answering mid-probe and
  # then stays dead, without sound, until it is unplugged or the machine
  # is powered off; a reboot does not reset it, and its retries at boot
  # hold up the input modules on the same hub. Seen 2026-10-16: "failed to
  # get firmware version info: ... USB error: Operation timed out".
  #
  # The plugin only covers this card's DSP and some Sennheiser/EPOS
  # headsets, so nothing else loses firmware updates. Firmware for the
  # card itself would have to be applied by hand.
  #
  # TODO(upstream): report to https://github.com/fwupd/fwupd/issues, then
  # link the issue here. Draft:
  #   Title: synaptics_cape: probe timeout leaves Framework Audio Expansion
  #          Card (32ac:0010) dead until power cycle
  #   Body: on a Framework Laptop 16, the plugin's firmware version query
  #   ("failed to get firmware version info: ... Operation timed out")
  #   sometimes leaves the card unresponsive: no audio, and at the next boot
  #   the kernel retries it with "device descriptor read/64, error -110",
  #   which delays the other devices on its hub. Only unplugging the card
  #   or powering off recovers it. Seen three times in a week (2026-10-12,
  #   -13, -16), each while fwupd was starting for the metadata refresh;
  #   none since disabling the plugin. Related: #8469 (slow boot on
  #   a Framework 16, same timeout), #50 (USB audio failing while fwupd
  #   runs). Attach `fwupdmgr --version` and the journal from a failure.
  services.fwupd.daemonSettings.DisabledPlugins = [ "synaptics_cape" ];
}
