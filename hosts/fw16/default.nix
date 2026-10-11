# Framework Laptop 16
{
  imports = [
    ../common/global
    ../common/users/f.nix

    ../common/optional/bluetooth.nix
    ../common/optional/fingerprint.nix
    ../common/optional/firefox.nix
    ../common/optional/networkmanager.nix
    ../common/optional/plasma.nix
    ../common/optional/secure-boot.nix

    ./filesystems.nix
    ./hibernation.nix
    ./tpm-unlock.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  networking.hostName = "fw16"; # Define your hostname.

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "26.05"; # Did you read the comment?
}
