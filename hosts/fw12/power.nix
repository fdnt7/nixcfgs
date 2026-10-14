{ config, ... }:
{
  # State that is saved at shutdown and restored at boot, which the wiped
  # root would otherwise forget: the screen backlight level, and the power
  # profile chosen in Plasma.
  environment.persistence.${config.impermanence.persist}.directories = [
    "/var/lib/systemd/backlight"
    "/var/lib/power-profiles-daemon"
  ];
}
