{ inputs, pkgs, ... }:
{
  home.packages = [
    # pkgs.osu-lazer-bin
    (inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-lazer-bin.override {
      gmrun_enable = false;
    })
  ];
}
