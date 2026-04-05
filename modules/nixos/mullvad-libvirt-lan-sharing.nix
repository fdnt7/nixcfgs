{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mdDoc
    mkEnableOption
    mkIf
    ;
  cfg = config.services.mullvad-libvirt-lan-sharing;
  mullvadCfg = config.services.mullvad-vpn;

  enableLanSharing = pkgs.writeShellScript "mullvad-libvirt-lan-sharing" ''
    set -eu

    i=0
    while [ "$i" -lt 30 ]; do
      if ${mullvadCfg.package}/bin/mullvad lan get >/dev/null 2>&1; then
        exec ${mullvadCfg.package}/bin/mullvad lan set allow
      fi

      i=$((i + 1))
      ${pkgs.coreutils}/bin/sleep 1
    done

    echo "mullvad daemon did not become ready in time" >&2
    exit 1
  '';
in
{
  options.services.mullvad-libvirt-lan-sharing.enable = mkEnableOption (
    mdDoc "enforce Mullvad local network sharing when using libvirt NAT"
  );

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = mullvadCfg.enable;
        message = "services.mullvad-libvirt-lan-sharing requires services.mullvad-vpn.enable.";
      }
      {
        assertion = config.virtualisation.libvirtd.enable;
        message = "services.mullvad-libvirt-lan-sharing requires virtualisation.libvirtd.enable.";
      }
    ];

    systemd.services.mullvad-daemon.serviceConfig.ExecStartPost = lib.mkAfter [ enableLanSharing ];
  };
}
