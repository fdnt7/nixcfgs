{
  # Needs system-level setup (32-bit graphics, udev rules for controllers),
  # so it cannot live in Home Manager.
  programs.steam.enable = true;

  # Prebuilt packages from the nix-gaming flake.
  nix.settings = {
    extra-substituters = [ "https://nix-gaming.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
  };
}
