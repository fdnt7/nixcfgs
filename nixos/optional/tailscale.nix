{ config, lib, ... }:
let
  tailnet = config.services.tailscale.interfaceName;

  # Mullvad's mark for traffic it leaves alone: on the connection, which its
  # firewall lets through, and on the packet, which its routing rule then
  # passes over to Tailscale's. Both are constants in Mullvad's source
  # (talpid-core), and what its own rules match on.
  mullvad = {
    ct = "0x00000f41";
    meta = "0x6d6f6c65";
  };
in
{
  services.tailscale.enable = true;
  # The node key and login state.
  environment.persistence.${config.impermanence.persist}.directories = [ "/var/lib/tailscale" ];

  # With Mullvad connected, its routing rule, put ahead of Tailscale's,
  # sends everything into its tunnel, the tailnet's addresses with the
  # rest, and its firewall drops what then comes in on the tailnet. So the
  # tailnet's traffic gets Mullvad's marks, as Mullvad documents for
  # traffic to leave out of its tunnel. tailscaled's own, the WireGuard and
  # relay traffic carrying the tailnet, stays in the tunnel, so that what
  # the tailnet sees is Mullvad's address. Tested on fw16 with Mullvad
  # 2026.5 and Tailscale 1.104.2, 2026-10-28.
  networking.nftables = lib.mkIf config.services.mullvad-vpn.enable {
    # Declared tables are made and replaced on their own; Mullvad's is left
    # as it is, as the ruleset is not flushed.
    enable = true;
    tables.tailscale-mullvad = {
      family = "inet";
      content = ''
        # after conntrack (-200), so that the connection can be marked, and
        # before Mullvad's filter chains (0); a route chain, so that the
        # packet is routed again with the mark
        chain output-mark {
          type route hook output priority -10; policy accept;
          ip daddr 100.64.0.0/10 ct mark set ${mullvad.ct} meta mark set ${mullvad.meta}
          ip6 daddr fd7a:115c:a1e0::/48 ct mark set ${mullvad.ct} meta mark set ${mullvad.meta}
        }

        # Tailscale's routes cover only the addresses in the tailnet, so
        # another in its range, marked above, would go out around Mullvad
        chain output-guard {
          type filter hook output priority -5; policy accept;
          meta mark ${mullvad.meta} ip daddr 100.64.0.0/10 oifname != "${tailnet}" counter drop
          meta mark ${mullvad.meta} ip6 daddr fd7a:115c:a1e0::/48 oifname != "${tailnet}" counter drop
        }

        # connections from the tailnet, before Mullvad's filter drops them
        chain input-mark {
          type filter hook input priority -10; policy accept;
          iifname "${tailnet}" ct mark set ${mullvad.ct}
        }
      '';
    };
  };
}
