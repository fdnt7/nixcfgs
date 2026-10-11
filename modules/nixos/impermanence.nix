# Root is recreated empty on every boot; the previous root is kept under
# /old_roots on the Btrfs top level for a while, in case something that
# should have been persisted was not. Based on the nix-community/impermanence
# README, run as a systemd initrd service as in
# https://notashelf.dev/posts/impermanence
#
# Modules that keep state declare it themselves, next to what creates it:
#
#   environment.persistence.${config.impermanence.persist}.directories = [ ... ];
{
  config,
  inputs,
  lib,
  pkgs,
  utils,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  cfg = config.impermanence;

  device = "/dev/mapper/${cfg.luksName}";
  deviceUnit = "${utils.escapeSystemdPath device}.device";
in
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  options.impermanence = {
    enable = mkEnableOption "an empty Btrfs root subvolume on every boot";

    luksName = mkOption {
      type = types.str;
      default = "enc";
      description = "Name of the opened LUKS device holding the Btrfs filesystem.";
    };

    keepDays = mkOption {
      type = types.ints.unsigned;
      default = 7;
      description = "Days to keep old roots before deleting them.";
    };

    persist = mkOption {
      type = types.str;
      default = "/persist";
      description = "Mount point of the persistent volume.";
    };
  };

  config = mkIf cfg.enable {
    boot.initrd.systemd = {
      enable = true;
      initrdBin = [
        pkgs.btrfs-progs
        pkgs.findutils
      ];

      services.rollback = {
        description = "Move the BTRFS root subvolume aside and start from an empty one";
        wantedBy = [ "initrd.target" ];
        requires = [ deviceUnit ];
        # After the resume attempt: a successful resume never returns, so the
        # root in use by the hibernated system is not moved aside.
        after = [
          deviceUnit
          "systemd-cryptsetup@${cfg.luksName}.service"
          "systemd-hibernate-resume.service"
        ];
        before = [ "sysroot.mount" ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = ''
          mkdir -p /btrfs_tmp
          mount -o subvol=/ ${device} /btrfs_tmp

          if [[ -e /btrfs_tmp/root ]]; then
            mkdir -p /btrfs_tmp/old_roots
            timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%d_%H-%M-%S")
            mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
          fi

          delete_subvolume_recursively() {
            IFS=$'\n'
            for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
            done
            btrfs subvolume delete "$1"
          }

          for i in $(find /btrfs_tmp/old_roots/ -mindepth 1 -maxdepth 1 -mtime +${toString cfg.keepDays}); do
            delete_subvolume_recursively "$i"
          done

          btrfs subvolume create /btrfs_tmp/root
          umount /btrfs_tmp
        '';
      };
    };

    environment.persistence.${cfg.persist}.hideMounts = true;
  };
}
