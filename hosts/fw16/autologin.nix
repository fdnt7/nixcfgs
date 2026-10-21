{ config, ... }:
{
  # Log straight into niri at boot. The TPM PIN that unlocks the disk has
  # already authenticated the only user by then; the lock screen covers
  # everything after. Logging out returns to the greeter.
  services.greetd.settings.initial_session = {
    # Through systemd-cat for the same reason as in the greeter:
    # ../../nixos/optional/greetd.nix.
    command = "${config.systemd.package}/bin/systemd-cat --identifier=session ${config.programs.niri.package}/bin/niri-session";
    user = "f";
  };
}
