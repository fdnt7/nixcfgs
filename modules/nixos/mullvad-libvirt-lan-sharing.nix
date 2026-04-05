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
    getExe
    mkIf
    ;
  cfg = config.services.mullvad-libvirt-lan-sharing;
  mullvadCfg = config.services.mullvad-vpn;

  enableLanSharing = pkgs.writeShellApplication {
    name = "mullvad-libvirt-lan-sharing";
    runtimeInputs = [
      mullvadCfg.package
      pkgs.coreutils
    ];
    text = ''
      set -euo pipefail

      i=0
      while [ "$i" -lt 30 ]; do
        if mullvad lan get >/dev/null 2>&1; then
          exec mullvad lan set allow
        fi

        i=$((i + 1))
        sleep 1
      done

      echo "mullvad daemon did not become ready in time" >&2
      exit 1
    '';
  };
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

    systemd.services.mullvad-daemon.serviceConfig.ExecStartPost = lib.mkAfter [
      (getExe enableLanSharing)
    ];
  };
}
