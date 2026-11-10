{ config, ... }:
let
  # Fixed, as the slice below is named after it. Below the range NixOS
  # hands out from the top (999 down), above the ones it reserves.
  uid = 400;
in
{
  # An account for long jobs sent here from another machine (./ssh.nix),
  # apart from f: they get this machine's threads, and nothing of f's.
  # Bash, as the commands arrive over ssh and are written for it.
  users.users.compute = {
    isSystemUser = true;
    inherit uid;
    group = "compute";
    home = "/var/lib/compute";
    useDefaultShell = true;
    # Its user manager runs from boot, so a job started with systemd-run
    # --user outlives the connection that started it.
    linger = true;
  };
  users.groups.compute.gid = uid;

  environment.persistence.${config.impermanence.persist}.directories = [
    {
      directory = config.users.users.compute.home;
      user = "compute";
      group = "compute";
      mode = "0700";
    }
  ];

  # A job that outgrows its memory is killed here, in its own slice, and
  # does not take the machine with it: one did, on 2026-10-28. No swap
  # either, which would slow the desktop down long before the limit.
  systemd.slices."user-${toString uid}" = {
    overrideStrategy = "asDropin";
    sliceConfig = {
      MemoryMax = "70%";
      MemorySwapMax = 0;
    };
  };
}
