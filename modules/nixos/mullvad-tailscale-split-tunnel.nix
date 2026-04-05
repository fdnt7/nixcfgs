{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mdDoc
    mkIf
    ;
  cfg = config.services.mullvad-tailscale-split-tunnel;

  mullvad-ts-rules = pkgs.writeText "mullvad-ts.rules" ''
    table inet mullvad-ts {
      # Exclude all IPs in range 100.64.0.0 to 100.127.255.255 from Mullvad
      # Similarly for IPv6
      chain outgoing {
        type route hook output priority 0; policy accept;
        ip daddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
        ip6 daddr fd7a:115c:a1e0::/48 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
      }

      # Exclude all traffic coming from tailscale0 from Mullvad
      chain incoming {
        type filter hook input priority -100; policy accept;
        iifname "tailscale0" ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
      }

      # Exclude the Tailscale DNS resolver from Mullvad
      chain excludeDns {
        type filter hook output priority -10; policy accept;
        ip daddr 100.100.100.100 udp dport 53 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
        ip daddr 100.100.100.100 tcp dport 53 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
      }
    }
  '';

  mullvad-ts-cleanup-rules = pkgs.writeText "mullvad-ts-cleanup.rules" ''
    table inet mullvad-ts
    delete table inet mullvad-ts
  '';
in
{
  options.services.mullvad-tailscale-split-tunnel = {
    enable = mkEnableOption (
      mdDoc "declarative nftables rules to exclude Tailscale traffic from Mullvad VPN."
    );
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.services.tailscale.enable;
        message = "services.mullvad-tailscale-split-tunnel requires services.tailscale to be enabled.";
      }
      {
        assertion = config.networking.nftables.enable;
        message = "services.mullvad-tailscale-split-tunnel requires networking.nftables to be enabled.";
      }
    ];

    # --- Warnings: recommended integrations ---
    warnings =
      (lib.optional (!config.services.resolved.enable)
        "services.mullvad-tailscale-split-tunnel works best with systemd-resolved enabled, as Mullvad's DNS integration expects it."
      )
      ++ (lib.optional (!config.services.mullvad-vpn.enable)
        "services.mullvad-tailscale-split-tunnel is most useful when services.mullvad-vpn is enabled, since the rules mark connections for Mullvad's policy routing."
      );

    systemd.services.tailscaled.serviceConfig = {
      ExecStartPre = [ "${pkgs.nftables}/bin/nft -f ${mullvad-ts-rules}" ];
      ExecStopPost = [ "${pkgs.nftables}/bin/nft -f ${mullvad-ts-cleanup-rules}" ];
    };
  };
}
