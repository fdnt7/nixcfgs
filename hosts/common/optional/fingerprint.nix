{ config, ... }:
{
  services.fprintd.enable = true;

  # fprintd only lets an active session verify by default. A lock screen that
  # claims the sensor the instant the machine resumes is sometimes refused,
  # leaving only the password for that lock if it does not retry. Measured
  # with hyprlock (4 of 10 resumes); not yet rechecked with the
  # DankMaterialShell lock screen that replaced it: resume ten times
  # without this rule, and drop it if the finger is always accepted.
  security.polkit.extraConfig = ''
    polkit.addRule(function (action, subject) {
      if (
        action.id == "net.reactivated.fprint.device.verify" &&
        subject.isInGroup("users")
      ) {
        return polkit.Result.YES;
      }
    });
  '';

  environment.persistence.${config.impermanence.persist}.directories = [ "/var/lib/fprint" ];
}
