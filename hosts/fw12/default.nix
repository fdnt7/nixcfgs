# Framework Laptop 12 (13th Gen Intel Core)
{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.framework-12-13th-gen-intel

    ../../nixos/global
    ../../nixos/users/k.nix

    ../../nixos/optional/bluetooth.nix
    ../../nixos/optional/mullvad.nix
    ../../nixos/optional/networkmanager.nix
    ../../nixos/optional/pipewire.nix
    ../../nixos/optional/plasma.nix
    ../../nixos/optional/secure-boot.nix
    ../../nixos/optional/sops.nix
    ../../nixos/optional/tailscale.nix
    ../../nixos/optional/tpm.nix
    ../../nixos/optional/waydroid.nix

    ./disk.nix
    ./hibernation.nix
    ./power.nix
    ./secrets.nix
    ./tpm-unlock.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  networking.hostName = "fw12"; # Define your hostname.

  # Times in 24 hours everywhere Plasma draws one by itself, the login and
  # lock screens among them, which follow the locale rather than the panel
  # clock's setting. The rest of the locale stays American English.
  i18n.extraLocaleSettings.LC_TIME = "en_GB.UTF-8";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "26.11"; # Did you read the comment?
}
