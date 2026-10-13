{ config, ... }:
{
  # No Node.js is installed for its own sake: Claude Code brings one along
  # and asks its npm a question at startup, which then leaves a cache and
  # logs in the home directory unless told where they belong.
  programs.npm = {
    enable = true;
    package = null;
    settings = {
      cache = "${config.xdg.cacheHome}/npm";
      logs-dir = "${config.xdg.stateHome}/npm/logs";
    };
  };
}
