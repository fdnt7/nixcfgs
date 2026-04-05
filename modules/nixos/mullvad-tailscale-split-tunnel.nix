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
    mkMerge
    ;
  cfg = config.services.mullvad-tailscale-split-tunnel;
  tailscaleRouteTable = 52;

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

  applyNftRules = pkgs.writeShellScript "mullvad-ts-apply-nft" ''
    set -eu

    nft_bin=${pkgs.nftables}/bin/nft
    cleanup_rules=${mullvad-ts-cleanup-rules}

    if "$nft_bin" list table inet mullvad-ts >/dev/null 2>&1; then
      "$nft_bin" -f "$cleanup_rules"
    fi

    exec "$nft_bin" -f ${mullvad-ts-rules}
  '';

  cleanupNftRules = pkgs.writeShellScript "mullvad-ts-cleanup-nft" ''
    set -eu

    nft_bin=${pkgs.nftables}/bin/nft

    if "$nft_bin" list table inet mullvad-ts >/dev/null 2>&1; then
      exec "$nft_bin" -f ${mullvad-ts-cleanup-rules}
    fi
  '';

  applyPolicyRule = pkgs.writeShellScript "mullvad-ts-apply-policy-rule" ''
    set -eu

    ip_bin=${pkgs.iproute2}/bin/ip
    grep_bin=${pkgs.gnugrep}/bin/grep
    sed_bin=${pkgs.gnused}/bin/sed
    sleep_bin=${pkgs.coreutils}/bin/sleep
    route_table=${toString tailscaleRouteTable}

    i=0
    while [ "$i" -lt 30 ]; do
      mullvad_rule_pref=$(
        "$ip_bin" rule show \
          | "$grep_bin" -F "fwmark 0x6d6f6c65 lookup 1836018789" \
          | "$sed_bin" -n '1s/:.*//p'
      )

      if [ -n "$mullvad_rule_pref" ]; then
        rule_pref=$((mullvad_rule_pref - 1))

        while "$ip_bin" -4 rule show | "$grep_bin" -Fq "to 100.64.0.0/10 lookup $route_table"; do
          "$ip_bin" -4 rule del to 100.64.0.0/10 lookup "$route_table"
        done

        exec "$ip_bin" -4 rule add pref "$rule_pref" to 100.64.0.0/10 lookup "$route_table"
      fi

      i=$((i + 1))
      "$sleep_bin" 1
    done

    echo "warning: Mullvad policy routing rule did not appear; skipping Tailscale IPv4 policy rule" >&2
    exit 0
  '';

  cleanupPolicyRule = pkgs.writeShellScript "mullvad-ts-cleanup-policy-rule" ''
    set -eu

    ip_bin=${pkgs.iproute2}/bin/ip
    grep_bin=${pkgs.gnugrep}/bin/grep
    route_table=${toString tailscaleRouteTable}

    while "$ip_bin" -4 rule show | "$grep_bin" -Fq "to 100.64.0.0/10 lookup $route_table"; do
      "$ip_bin" -4 rule del to 100.64.0.0/10 lookup "$route_table"
    done
  '';
in
{
  options.services.mullvad-tailscale-split-tunnel = {
    enable = mkEnableOption (
      mdDoc "declarative nftables rules to exclude Tailscale traffic from Mullvad VPN."
    );
  };

  config = mkMerge [
    (mkIf cfg.enable {
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
        ExecStartPre = [ applyNftRules ];
        ExecStopPost = [ cleanupNftRules ];
      };
    })

    (mkIf (cfg.enable && config.services.mullvad-vpn.enable) {
      systemd.services.mullvad-daemon.serviceConfig = {
        ExecStartPost = lib.mkAfter [ applyPolicyRule ];
        ExecStopPost = lib.mkAfter [ cleanupPolicyRule ];
      };
    })
  ];
}
