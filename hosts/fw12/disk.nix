# The whole disk, as disko creates it at install time and mounts it after:
# a boot partition and one encrypted Btrfs volume, laid out as on fw16.
# ./hardware-configuration.nix is generated with `--no-filesystems` for
# that reason.
{ config, inputs, ... }:
let
  options = [
    "compress=zstd"
    "noatime"
  ];
in
{
  imports = [ inputs.disko.nixosModules.disko ];

  disko.devices.disk.main = {
    type = "disk";
    # Only read when the disk is created: the mounts go by partition
    # label. The machine has room for one drive.
    device = "/dev/nvme0n1";
    content = {
      type = "gpt";
      partitions = {
        boot = {
          size = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [
              "fmask=0077"
              "dmask=0077"
            ];
          };
        };
        enc = {
          size = "100%";
          content = {
            type = "luks";
            name = config.impermanence.luksName;
            # Read once, when the volume is created; the installer puts
            # the passphrase there.
            passwordFile = "/tmp/disk.key";
            content = {
              type = "btrfs";
              subvolumes = {
                root = {
                  mountpoint = "/";
                  mountOptions = options;
                };
                home = {
                  mountpoint = "/home";
                  mountOptions = options;
                };
                nix = {
                  mountpoint = "/nix";
                  mountOptions = options;
                };
                persist = {
                  mountpoint = config.impermanence.persist;
                  mountOptions = options;
                };
                log = {
                  mountpoint = "/var/log";
                  mountOptions = options;
                };
                # Holds the swap file, which must not be compressed. As
                # large as the memory, so the machine can hibernate.
                swap = {
                  mountpoint = "/swap";
                  mountOptions = [ "noatime" ];
                  swap.swapfile.size = "48G";
                };
              };
            };
          };
        };
      };
    };
  };

  fileSystems = {
    ${config.impermanence.persist}.neededForBoot = true;
    "/var/log".neededForBoot = true;
  };
}
