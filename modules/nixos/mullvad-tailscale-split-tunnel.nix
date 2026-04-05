# This module started as a Nix translation of:
#   https://github.com/hypergonial/arch_repo/tree/main/mullvad-tailscale-split-tunnel
#
# The upstream Arch package is intentionally tiny: it installs a small nftables
# table from tailscaled's ExecStartPre and removes it on ExecStopPost. That
# model assumes two things:
#   1. marking Tailscale traffic in nftables is sufficient by itself, and
#   2. Mullvad will not later rewrite the routing / firewall state in a way
#      that invalidates the one-shot setup.
#
# On this NixOS host those assumptions did not hold. Live tracing and fresh
# boot verification showed that Mullvad continued mutating both RPDB state and
# its own nftables chains after the one-shot setup had already run. The end
# result was:
#   - IPv6 to Tailscale peers worked, because Mullvad already allows ULA
#     traffic (fc00::/7), which covers Tailscale's fd7a:... addresses.
#   - IPv4 to Tailscale peers still failed, because 100.64.0.0/10 is not
#     treated as ordinary LAN traffic by Mullvad.
#   - A plain translation of the Arch package therefore left host->peer IPv4
#     either routed back into wg0-mullvad or blocked by Mullvad's output
#     policy after boot.
#
# This module keeps the original nftables table for the parts it still does
# well, but adds a long-running reconciler to enforce the steady state that
# the Arch package assumes already exists.
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

  # Tailscale installs its Linux routes into table 52. We route Tailscale's
  # IPv4 CGNAT range into that table explicitly so it wins before Mullvad's
  # catch-all policy rules.
  tailscaleRouteTable = 52;

  # These rules are the direct descendants of the Arch package's ruleset. They
  # still matter here, but they are no longer the whole solution:
  #   - `outgoing` keeps the documented Mullvad split-tunnel marks for traffic
  #     that does traverse this hook.
  #   - `incoming` marks packets arriving from tailscale0 so Mullvad's input /
  #     forward policy does not drop reply traffic.
  #   - `excludeDns` preserves reachability to Tailscale's stub resolver.
  #
  # What the Arch version missed is that these rules alone do not guarantee the
  # final post-boot steady state on this host.
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

  # Keep the Arch behaviour for installing the helper nft table when tailscaled
  # comes up. This is still useful for incoming traffic, Tailscale DNS, and the
  # generic "mark traffic for Mullvad split tunnelling" behaviour.
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

  # Mirror the upstream cleanup behaviour so a stop/restart of tailscaled removes
  # the private table cleanly.
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

  # This guard is the real divergence from the Arch package.
  #
  # Why it exists:
  #   - A one-shot `ExecStartPre` on tailscaled is too early on this host.
  #   - A one-shot `ExecStartPost` on mullvad-daemon is still too early.
  #   - Mullvad keeps adjusting both policy routing and nftables while the
  #     tunnel transitions to Connected.
  #
  # What the guard enforces after Mullvad has actually settled:
  #   1. An RPDB rule for 100.64.0.0/10 that stays ahead of Mullvad's own
  #      policy rules and therefore routes peer IPv4 via table 52 / tailscale0.
  #   2. A dedicated accept rule in `inet mullvad output` for 100.64.0.0/10.
  #
  # The second point is the important dataplane detail the Arch package missed
  # for this machine. Manual testing showed that even with the correct route in
  # place, Mullvad's output chain still rejected Tailscale IPv4 until an
  # explicit `accept` for 100.64.0.0/10 was inserted there.
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

      # The rule comment is used as a stable ownership marker so we can insert
      # and remove only the rule managed by this module.
      route_table=${toString tailscaleRouteTable}
      rule_comment="mullvad-ts-tailscale-ipv4"

      cleanup_state() {
        local handle

        # Remove every copy of our destination rule. Mullvad may reshuffle rule
        # priorities across reconnects, so cleanup cannot assume a fixed pref.
        while ip -4 rule show | grep -Fq "to 100.64.0.0/10 lookup $route_table"; do
          ip -4 rule del to 100.64.0.0/10 lookup "$route_table"
        done

        # Remove only the output-chain rule we own.
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
        # Mullvad keeps rewriting policy state until the tunnel is really up.
        # Do nothing before then; otherwise our desired state is likely to be
        # overwritten moments later.
        if mullvad status 2>/dev/null | grep -Fxq "Connected"; then
          desired_pref="$(
            ip rule show \
              | sed -n '/lookup main suppress_prefixlength 0\|fwmark 0x6d6f6c65 lookup 1836018789/s/:.*//p' \
              | sort -n \
              | head -n 1
          )"

          # We anchor ourselves immediately ahead of the earliest Mullvad-owned
          # routing rule instead of hard-coding a priority. The exact Mullvad
          # preferences have changed across boots and reconnects on this host.
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

              # Route all Tailscale IPv4 peers through Tailscale's own table
              # before Mullvad gets a chance to steer them back into wg0.
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
              # Mullvad's output chain is `policy drop` and 100.64.0.0/10 is
              # not part of the RFC1918 ranges it already treats as LAN. This
              # explicit allow rule is what made host->peer IPv4 ping succeed
              # during live testing.
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
    enable = mkEnableOption (mdDoc ''
      declarative Mullvad/Tailscale split tunnelling.

      Compared to the original Arch package this module does more than install
      a small nftables table at tailscaled startup: it also keeps Mullvad's
      policy routing and output firewall state aligned with the desired
      Tailscale IPv4 datapath after boot and reconnects.
    '');
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
          "services.mullvad-tailscale-split-tunnel is most useful when services.mullvad-vpn is enabled, since the rules are designed around Mullvad's policy routing and firewall."
        );

      systemd.services.tailscaled.serviceConfig = {
        # Preserve the original Arch integration point for the helper nft table.
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
          # Run continuously so the desired state survives Mullvad reconnects
          # and post-start rewrites. A one-shot service was not sufficient.
          Type = "simple";
          ExecStart = getExe mullvadStateGuard;
          Restart = "always";
          RestartSec = 2;
        };
      };
    })
  ];
}
