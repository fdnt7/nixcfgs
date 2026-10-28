{ config, ... }:
{
  # State that is saved at shutdown and restored at boot, which the wiped
  # root would otherwise forget: the screen backlight level, and the power
  # profile chosen in Plasma.
  environment.persistence.${config.impermanence.persist}.directories = [
    "/var/lib/systemd/backlight"
    "/var/lib/power-profiles-daemon"
  ];

  # The Intel card's power saving, which iwlwifi turns on, held packets
  # for the radio's next wake: pings from fw16 over the tailnet averaged
  # 126 ms and reached 430. With it off, 12 ms and 19 (2026-10-28), for
  # the little the radio then draws awake.
  networking.networkmanager.wifi.powersave = false;
}
