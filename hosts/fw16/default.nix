# Framework Laptop 16 (AMD Ryzen AI 300 Series, NVIDIA expansion bay module)
{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.framework-16-amd-ai-300-series-nvidia

    ../../nixos/global
    ../../nixos/users/f.nix

    ../../nixos/optional/bluetooth.nix
    ../../nixos/optional/noctalia.nix
    ../../nixos/optional/fingerprint.nix
    ../../nixos/optional/gaming.nix
    ../../nixos/optional/greetd.nix
    ../../nixos/optional/immich.nix
    ../../nixos/optional/mullvad.nix
    ../../nixos/optional/networkmanager.nix
    ../../nixos/optional/niri.nix
    ../../nixos/optional/pipewire.nix
    ../../nixos/optional/secure-boot.nix
    ../../nixos/optional/tpm.nix

    ./autologin.nix
    ./filesystems.nix
    ./fwupd.nix
    ./graphics.nix
    ./hibernation.nix
    ./power.nix
    ./tpm-unlock.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  networking.hostName = "fw16"; # Define your hostname.

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "26.05"; # Did you read the comment?
}
