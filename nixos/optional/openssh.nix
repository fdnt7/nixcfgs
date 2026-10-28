{ config, ... }:
{
  # An SSH server reached over the tailnet alone: the port is open on its
  # interface and nowhere else, and only keys get in. Who may log in is
  # each host's own: users.users.<name>.openssh.authorizedKeys.
  services.openssh = {
    enable = true;
    openFirewall = false;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };
  networking.firewall.interfaces.${config.services.tailscale.interfaceName}.allowedTCPPorts =
    config.services.openssh.ports;
}
