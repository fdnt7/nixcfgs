{ lib, ... }:
{
  # Tray icon for the daemon in ../../../../nixos/optional/tailscale.nix.
  services.tailscale-systray.enable = true;

  # Ordered after the shell as the Mullvad client is, ./mullvad.nix: an
  # icon registered before the tray host is up may go missing.
  systemd.user.services.tailscale-systray.Unit.After = lib.mkAfter [ "dms.service" ];
}
