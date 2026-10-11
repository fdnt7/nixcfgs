# What nixos-generate-config cannot detect; merged into the mounts declared
# in ./hardware-configuration.nix.
{ config, lib, ... }:
let
  # After the generated "subvol=..." option.
  options = lib.mkAfter [
    "compress=zstd"
    "noatime"
  ];
in
{
  fileSystems = {
    "/".options = options;
    "/home".options = options;
    "/nix".options = options;

    ${config.impermanence.persist} = {
      inherit options;
      neededForBoot = true;
    };

    "/var/log" = {
      inherit options;
      neededForBoot = true;
    };

    # Holds the swap file, which must not be compressed.
    "/swap".options = lib.mkAfter [ "noatime" ];
  };

  swapDevices = [
    { device = "/swap/swapfile"; }
  ];
}
