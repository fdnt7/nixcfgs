{
  config,
  lib,
  pkgs,
  ...
}:
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
    ];
  };

  # Where tuigreet remembers the last user and session.
  environment.persistence.${config.impermanence.persist}.directories = [ "/var/cache/tuigreet" ];
}
