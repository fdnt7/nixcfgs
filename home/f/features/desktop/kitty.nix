{ config, ... }:
{
  # The terminal, chosen on 2026-10-26 over foot and Ghostty: with
  # --single-instance, kitty's launcher hands the command line to the
  # running instance in C, before any Python starts, so a window opens as
  # fast as footclient's. Ghostty opened its windows a beat later.
  programs.kitty = {
    enable = true;
    settings = {
      # The family comes from ./fonts.nix.
      font_family = "monospace";
      font_size = 9;
    };
    # Catppuccin, dark or light as the desktop prefers, switched live: kitty
    # asks for the desktop's colour scheme and follows its changes. Dux
    # Shell's light mode reports no preference rather than light, so that
    # is Latte too; Plasma, on fw12, reports both. The shell's own colours
    # (`include dank-theme.conf`) were too high in contrast.
    autoThemeFiles = {
      dark = "Catppuccin-Mocha";
      light = "Catppuccin-Latte";
      noPreference = "Catppuccin-Latte";
    };
  };

  # The instance closes with its last window, and starting one takes about
  # 100 ms of Python. This one runs from login, its first window hidden, as
  # kitty's documentation describes for a background instance that acts as
  # a server; kitty has no daemon mode of its own. The hidden window holds
  # a shell nobody sees, which idles.
  systemd.user.services.kitty = {
    Unit = {
      Description = "kitty, held open for --single-instance";
      Documentation = "man:kitty(1)";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
      # Every window is the instance's, so restarting it on a switch would
      # close them all, the one running the switch with them. A new kitty
      # takes over at the next login; settings reach the running one
      # anyway, as the module signals it to reload.
      X-SwitchMethod = "keep-old";
    };
    Service = {
      ExecStart = "${config.programs.kitty.package}/bin/kitty --single-instance --start-as=hidden";
      Restart = "on-failure";
      # A window's program running out of memory is not kitty's failure.
      OOMPolicy = "continue";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
