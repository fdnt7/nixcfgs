{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.impermanence;
in
{
  options.impermanence.enable = mkEnableOption "Automatic rollback of Btrfs root subvolume during early boot.";

  config = mkIf cfg.enable {
    # currently, there is no way to permanently disable passphrase echoing
    # ref: https://github.com/systemd/systemd/issues/8495

    boot.initrd.systemd = {
      enable = true; # this enabled systemd support in stage1 - required for the below setup
      services.rollback = {
        description = "Rollback BTRFS root subvolume to a pristine state";
        wantedBy = [ "initrd.target" ];

        # LUKS/TPM process. If you have named your device mapper something other
        # than 'enc', then @enc will have a different name. Adjust accordingly.
        after = [ "systemd-cryptsetup@enc.service" ];

        # Before mounting the system root (/sysroot) during the early boot process
        before = [ "sysroot.mount" ];

        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = ''
          mkdir -p /mnt

          # We first mount the BTRFS root to /mnt
          # so we can manipulate btrfs subvolumes.
          mount -o subvol=/ /dev/mapper/enc /mnt

          # While we're tempted to just delete /root and create
          # a new snapshot from /root-blank, /root is already
          # populated at this point with a number of subvolumes,
          # which makes `btrfs subvolume delete` fail.
          # So, we remove them first.
          #
          # /root contains subvolumes:
          # - /root/var/lib/portables
          # - /root/var/lib/machines

          btrfs subvolume list -o /mnt/root |
            cut -f9 -d' ' |
            while read subvolume; do
              echo "deleting /$subvolume subvolume..."
              btrfs subvolume delete "/mnt/$subvolume"
            done &&
            echo "deleting /root subvolume..." &&
            btrfs subvolume delete /mnt/root
          echo "restoring blank /root subvolume..."
          btrfs subvolume snapshot /mnt/root-blank /mnt/root

          # Once we're done rolling back to a blank snapshot,
          # we can unmount /mnt and continue on the boot process.
          umount /mnt
        '';
      };
    };
  };
}
