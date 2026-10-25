{ config, ... }:
{
  # On trial beside ./foot.nix, from 2026-10-26: one instance runs in the
  # background, so a window should open as fast as footclient's, and the
  # shell recolours it when its theme changes, which it does not do for foot.
  #
  # The instance is the systemd unit Ghostty ships, which the module installs;
  # D-Bus starts it on the first `ghostty +new-window`, so only that first
  # window waits on startup.
  programs.ghostty = {
    enable = true;
    settings = {
      # The family comes from ./fonts.nix, at foot's size.
      font-family = "monospace";
      font-size = 9;
      # The colours the shell writes, and tells Ghostty to reload when they
      # change. Read as a file of settings rather than as a theme, behind a
      # `?`, as the shell writes it only once it next makes its colours, and
      # until then the module's check of the config would fail on a theme
      # that isn't there.
      config-file = "?${config.xdg.configHome}/ghostty/themes/dankcolors";
    };
  };
}
