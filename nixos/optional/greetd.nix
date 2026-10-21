{
  config,
  lib,
  pkgs,
  ...
}:
let
  journal = "${config.systemd.package}/bin/systemd-cat";
in
{
  # Minimal login manager with a text greeter. Like the console, it shows
  # PAM's prompts, so the fingerprint reader works without ceremony.
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings.default_session.command = lib.concatStringsSep " " [
      (lib.getExe pkgs.tuigreet)
      "--time"
      "--remember"
      "--remember-session"
      "--sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions"
      # What a session prints as it starts goes to the journal, not over
      # the greeter: niri-session draws a warning from systemd there.
      "--session-wrapper '${journal} --identifier=session'"
    ];
  };

  # Where tuigreet remembers the last user and session.
  environment.persistence.${config.impermanence.persist}.directories = [ "/var/cache/tuigreet" ];
}
