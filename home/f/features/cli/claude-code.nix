{ config, ... }:
{
  programs.claude-code = {
    enable = true;
    configDir = "${config.xdg.configHome}/claude";
  };

  # Its links, such as the one that finishes a login in the browser. The
  # handler is an entry Claude Code writes for itself when it runs.
  xdg.mimeApps.defaultApplications."x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
}
