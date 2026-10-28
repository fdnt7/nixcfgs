{ pkgs, ... }:
{
  # GitHub's published host key (https://api.github.com/meta), so the first
  # connection needs no trust-on-first-use prompt.
  programs.ssh.knownHosts."github.com".publicKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";

  # fw12's, made by its sshd on 2026-10-28 and checked against it then,
  # under its tailnet address, which ../../home/f/features/cli/ssh.nix
  # reaches it by.
  programs.ssh.knownHosts.fw12 = {
    hostNames = [ "100.98.146.116" ];
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILHRPbXriHM0GNrrVWVzDgiXN1gfyibexrdkH1wPp9+g";
  };

  # fw16's, made by its sshd on 2026-10-28 and read off it then, under its
  # tailnet address, which ../../home/k/fw12.nix reaches it by.
  programs.ssh.knownHosts.fw16 = {
    hostNames = [ "100.127.15.43" ];
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICPb+9NstzFkRQdycYjBxDa+oUbBZfx/gndZg83Hovzy";
  };

  # Every user's shared SSH connections (ControlMaster, as in
  # ../../home/f/features/cli/ssh.nix) are ended before sleep. One left open
  # through it is dead on waking, and the first command to use it waits
  # for the keepalives to give up, 25 seconds on fw16, before a new one is
  # made; ended, the first command just makes a new one. pkill returns at
  # once, so it cannot hold up a suspend or a shutdown, which this runs
  # before too. A shared connection names itself `ssh: <socket> [mux]`.
  powerManagement.powerDownCommands = ''
    ${pkgs.procps}/bin/pkill --full '^ssh: .* \[mux\]$' || true
  '';
}
