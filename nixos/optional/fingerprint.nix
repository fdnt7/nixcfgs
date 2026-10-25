{ config, ... }:
{
  services.fprintd.enable = true;

  # fprintd only lets an active session verify by default, which hyprlock
  # lost a race with on 4 of 10 resumes, claiming the sensor before the
  # session was active again; a polkit rule letting users verify made up for
  # it. The DankMaterialShell lock screen that replaced hyprlock needs no
  # such rule: without it, it unlocked on the first touch on 10 of 10 resumes
  # (2026-10-25).

  environment.persistence.${config.impermanence.persist}.directories = [ "/var/lib/fprint" ];
}
