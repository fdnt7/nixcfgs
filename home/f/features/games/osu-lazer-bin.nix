{ inputs, pkgs, ... }:
{
  # From nix-gaming, which tracks releases closely; its binary cache is set
  # up in ../../../../hosts/common/optional/gaming.nix. There is no module.
  home.packages = [
    inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-lazer-bin
  ];
}
