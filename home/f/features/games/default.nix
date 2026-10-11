# Steam itself is system-wide: ../../../../hosts/common/optional/gaming.nix.
{
  imports = [
    ./osu-lazer-bin.nix
    ./prismlauncher.nix
  ];
}
