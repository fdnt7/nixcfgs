{
  # Sound server, with the ALSA and PulseAudio interfaces programs expect.
  # rtkit lets it ask for real-time scheduling.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
}
