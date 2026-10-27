{ config, lib, ... }:
let
  tailnet = config.services.tailscale.interfaceName;

  # Mullvad's mark for connections it leaves alone, which its firewall lets
  # through: a constant in Mullvad's source (talpid-core), and what its own
  # rules match on.
  mullvadExcluded = "0x00000f41";
in
{
  services.tailscale.enable = true;
  # The node key and login state.
  environment.persistence.${config.impermanence.persist}.directories = [ "/var/lib/tailscale" ];

  # With Mullvad connected, its routing rules sit ahead of any others,
  # Tailscale's included, and send everything into its tunnel; its
  # firewall then drops whatever leaves or arrives elsewhere. Tested on
  # fw16 and fw12 with Mullvad 2026.5 and Tailscale 1.104.2, 2026-10-28.
  #
  # Ahead of its own catch-all, Mullvad looks in the main table for any
  # route more specific than the default, as it does for the local
  # network: a route there for the tailnet's range takes it to the
  # tailnet. From the start, so that a connection has the tailnet's
  # address and interface from its first packet; rerouting each packet
  # instead lost what a host sent in bulk on a connection it had accepted.
  # An address in the range outside the tailnet goes to tailscaled too,
  # which has no peer for it, and so not around Mullvad.
  #
  # tailscaled's own traffic, the WireGuard and relay traffic carrying the
  # tailnet, stays in the tunnel, so that what the tailnet sees is
  # Mullvad's address.
  networking = lib.mkIf config.services.mullvad-vpn.enable {
    # Made each time tailscaled makes the interface: the service NixOS
    # makes for these is bound to the device.
    interfaces.${tailnet} = {
      ipv4.routes = [
        {
          address = "100.64.0.0";
          prefixLength = 10;
        }
      ];
      ipv6.routes = [
        {
          address = "fd7a:115c:a1e0::";
          prefixLength = 48;
        }
      ];
    };

    # And Mullvad's mark on the tailnet's connections, both ways, before
    # its filter chains (0) and after conntrack (-200).
    nftables = {
      # Declared tables are made and replaced on their own; Mullvad's is
      # left as it is, as the ruleset is not flushed.
      enable = true;
      tables.tailscale-mullvad = {
        family = "inet";
        content = ''
          chain output {
            type filter hook output priority -10; policy accept;
            oifname "${tailnet}" ct mark set ${mullvadExcluded}
          }

          chain input {
            type filter hook input priority -10; policy accept;
            iifname "${tailnet}" ct mark set ${mullvadExcluded}
          }
        '';
      };
    };
  };
}
