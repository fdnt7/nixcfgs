# Framework Laptop 16 (AMD Ryzen AI 300 Series, NVIDIA expansion bay module)
{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.framework-16-amd-ai-300-series-nvidia

    ../common/global
    ../common/users/f.nix

    ../common/optional/bluetooth.nix
    ../common/optional/dms.nix
    ../common/optional/fingerprint.nix
    ../common/optional/gaming.nix
    ../common/optional/greetd.nix
    ../common/optional/immich.nix
    ../common/optional/mullvad.nix
    ../common/optional/networkmanager.nix
    ../common/optional/niri.nix
    ../common/optional/pipewire.nix
    ../common/optional/secure-boot.nix
    ../common/optional/tpm.nix

    ./autologin.nix
    ./filesystems.nix
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
