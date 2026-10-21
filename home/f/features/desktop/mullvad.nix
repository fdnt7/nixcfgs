{ pkgs, ... }:
{
  # The daemon and client are system-wide:
  # ../../../../nixos/optional/mullvad.nix. This starts the client
  # with the session, for its tray icon. Connecting on boot is the daemon's
  # own setting, `mullvad auto-connect set on`, kept with its state.
  #
  # A service rather than an autostart entry, only to order it after the
  # shell: the two would otherwise start together, and the client goes
  # without a tray icon if it comes up first. The target has to be named
  # too, as the shell is ordered after it: left out, systemd orders this
  # unit before the target instead, which is a cycle.
  systemd.user.services.mullvad-vpn-gui = {
    Unit = {
      Description = "Mullvad VPN client";
      After = [
        "graphical-session.target"
        "dms.service"
      ];
      PartOf = [ "graphical-session.target" ];
    };
    Service.ExecStart = "${pkgs.mullvad-vpn}/bin/mullvad-vpn";
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
