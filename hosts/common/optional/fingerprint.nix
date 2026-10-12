{ config, ... }:
{
  services.fprintd.enable = true;

  # fprintd only lets an active session verify by default. A lock screen that
  # claims the sensor the instant the machine resumes is sometimes refused,
  # and hyprlock does not retry, leaving only the password for that lock.
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
