{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    getExe
    mdDoc
    mkEnableOption
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

  applyNftRules = pkgs.writeShellApplication {
    name = "mullvad-ts-apply-nft";
    runtimeInputs = [ pkgs.nftables ];
    text = ''
      set -euo pipefail

      cleanup_rules='${mullvad-ts-cleanup-rules}'

      if nft list table inet mullvad-ts >/dev/null 2>&1; then
        nft -f "$cleanup_rules"
      fi

      exec nft -f '${mullvad-ts-rules}'
    '';
  };

  cleanupNftRules = pkgs.writeShellApplication {
    name = "mullvad-ts-cleanup-nft";
    runtimeInputs = [ pkgs.nftables ];
    text = ''
      set -euo pipefail

      if nft list table inet mullvad-ts >/dev/null 2>&1; then
        exec nft -f '${mullvad-ts-cleanup-rules}'
      fi
    '';
  };

  mullvadStateGuard = pkgs.writeShellApplication {
    name = "mullvad-ts-state-guard";
    runtimeInputs = [
      config.services.mullvad-vpn.package
      pkgs.coreutils
      pkgs.gnugrep
      pkgs.gnused
      pkgs.iproute2
      pkgs.nftables
    ];
    text = ''
      set -euo pipefail

      route_table=${toString tailscaleRouteTable}
      rule_comment="mullvad-ts-tailscale-ipv4"

      cleanup_state() {
        local handle

        while ip -4 rule show | grep -Fq "to 100.64.0.0/10 lookup $route_table"; do
          ip -4 rule del to 100.64.0.0/10 lookup "$route_table"
        done

        if nft list chain inet mullvad output >/dev/null 2>&1; then
          while :; do
            handle="$(
              nft -a list chain inet mullvad output \
                | sed -n "/comment \"$rule_comment\"/s/.*# handle \([0-9][0-9]*\)$/\1/p" \
                | head -n 1
            )"

            if [ -z "$handle" ]; then
              break
            fi

            nft delete rule inet mullvad output handle "$handle"
          done
        fi
      }

      trap cleanup_state EXIT INT TERM

      while :; do
        if mullvad status 2>/dev/null | grep -Fxq "Connected"; then
          desired_pref="$(
            ip rule show \
              | sed -n '/lookup main suppress_prefixlength 0\|fwmark 0x6d6f6c65 lookup 1836018789/s/:.*//p' \
              | sort -n \
              | head -n 1
          )"

          if [ -n "$desired_pref" ] && [ "$desired_pref" -gt 0 ]; then
            current_pref="$(
              ip -4 rule show \
                | sed -n "/to 100.64.0.0\\/10 lookup $route_table/s/:.*//p" \
                | head -n 1
            )"
            desired_pref=$((desired_pref - 1))

            if [ "$current_pref" != "$desired_pref" ]; then
              while ip -4 rule show | grep -Fq "to 100.64.0.0/10 lookup $route_table"; do
                ip -4 rule del to 100.64.0.0/10 lookup "$route_table"
              done

              ip -4 rule add pref "$desired_pref" to 100.64.0.0/10 lookup "$route_table"
            fi
          fi

          if nft list chain inet mullvad output >/dev/null 2>&1; then
            handle="$(
              nft -a list chain inet mullvad output \
                | sed -n "/comment \"$rule_comment\"/s/.*# handle \([0-9][0-9]*\)$/\1/p" \
                | head -n 1
            )"

            if [ -z "$handle" ]; then
              nft insert rule inet mullvad output position 0 ip daddr 100.64.0.0/10 accept comment "$rule_comment"
            fi
          fi
        fi

        sleep 2
      done
    '';
  };
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
        ExecStartPre = [ (getExe applyNftRules) ];
        ExecStopPost = [ (getExe cleanupNftRules) ];
      };
    })

    (mkIf (cfg.enable && config.services.mullvad-vpn.enable) {
      systemd.services.mullvad-tailscale-split-tunnel = {
        description = "Keep Tailscale split-tunnel rules aligned with Mullvad";
        wantedBy = [ "multi-user.target" ];
        wants = [
          "mullvad-daemon.service"
          "tailscaled.service"
        ];
        after = [
          "mullvad-daemon.service"
          "tailscaled.service"
        ];
        partOf = [
          "mullvad-daemon.service"
          "tailscaled.service"
        ];
        serviceConfig = {
          Type = "simple";
          ExecStart = getExe mullvadStateGuard;
          Restart = "always";
          RestartSec = 2;
        };
      };
    })
  ];
}
