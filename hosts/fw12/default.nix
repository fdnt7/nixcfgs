# Framework Laptop 12 (13th Gen Intel Core)
{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.framework-12-13th-gen-intel

    ../common/global
    ../common/users/k.nix

    ../common/optional/bluetooth.nix
    ../common/optional/mullvad.nix
    ../common/optional/networkmanager.nix
    ../common/optional/pipewire.nix
    ../common/optional/plasma.nix
    ../common/optional/secure-boot.nix
    ../common/optional/sops.nix
    ../common/optional/tailscale.nix
    ../common/optional/tpm.nix
    ../common/optional/virtual-keyboard.nix
    ../common/optional/waydroid.nix

    ./disk.nix
    ./hibernation.nix
    ./power.nix
    ./secrets.nix
    ./tpm-nvpcr.nix
    ./tpm-unlock.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  networking.hostName = "fw12"; # Define your hostname.

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "26.11"; # Did you read the comment?
}
