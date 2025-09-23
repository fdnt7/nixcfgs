{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  # A shorthand for our module's configuration options.
  cfg = config.services.mullvad-tailscale;

  # The nftables rules for excluding Tailscale traffic from Mullvad.
  mullvad-ts-rules = pkgs.writeText "mullvad-ts.rules" ''
    #!/usr/sbin/nft -f

    table inet mullvad-ts {
      # For locally generated packets, mark those destined for the Tailscale network
      # to bypass the Mullvad VPN. This handles outgoing connections and their replies.
      chain outgoing {
        type route hook output priority 0; policy accept;
        ip daddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
        ip6 daddr fd7a:115c:a1e0::/48 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
      }

      # FIX for incoming connections:
      # For packets arriving from the Tailscale network, we must mark the connection track
      # *before* Mullvad's own firewall rules can drop the packet.
      # We use the 'prerouting' hook which runs very early for incoming packets,
      # ensuring the packet and its connection are marked for exclusion before any filtering occurs.
      chain prerouting_tailscale {
        # The 'mangle' priority (-150) is standard for this kind of packet modification.
        type filter hook prerouting priority mangle; policy accept;
        iifname "tailscale0" ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
      }

      # Exclude Tailscale's MagicDNS resolver (100.100.100.100) from Mullvad.
      chain excludeDns {
        type filter hook output priority -10; policy accept;
        ip daddr 100.100.100.100 udp dport 53 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
        ip daddr 100.100.100.100 tcp dport 53 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
      }
    }
  '';

  # The nftables command to clean up the rules when tailscaled stops.
  mullvad-ts-cleanup-rules = pkgs.writeText "mullvad-ts-cleanup.rules" ''
    #!/usr/sbin/nft -f

    # This command deletes the entire table created by the rules above.
    delete table inet mullvad-ts
  '';
in {
  # --- Module Options ---
  # This section defines the configuration options that users can set.
  options.services.mullvad-tailscale = {
    enable = mkEnableOption (mdDoc "declarative nftables rules to exclude Tailscale traffic from Mullvad VPN.");
  };

  # --- Module Configuration ---
  # This section defines the system configuration that will be applied if the module is enabled.
  config = mkIf cfg.enable {
    # Assertions check for required dependencies and provide helpful error messages.
    assertions = [
      {
        assertion = config.services.tailscale.enable;
        message = "services.mullvad-tailscale requires services.tailscale to be enabled.";
      }
      {
        # The Mullvad client's DNS features integrate with systemd-resolved.
        assertion = config.services.resolved.enable;
        message = "services.mullvad-tailscale is designed to work with systemd-resolved. Please enable services.resolved.";
      }
      {
        assertion = config.networking.nftables.enable;
        message = "services.mullvad-tailscale requires networking.nftables to be enabled.";
      }
    ];

    # This is the declarative way to create a systemd "drop-in" file.
    # It modifies the tailscaled service unit.
    systemd.services.tailscaled.serviceConfig = {
      # ExecStartPre runs this command before starting the main tailscaled process.
      # We use the full path to the nft binary from the nftables package and the path to our rules file in the Nix store.
      ExecStartPre = "${pkgs.nftables}/bin/nft -f ${mullvad-ts-rules}";

      # ExecStopPost runs this command after the main tailscaled process has stopped.
      ExecStopPost = "${pkgs.nftables}/bin/nft -f ${mullvad-ts-cleanup-rules}";
    };
  };
}
