{
  config,
  inputs,
  pkgs,
  ...
}:
{
  # The original osu!, under Wine, beside the new one: ./osu-lazer-bin.nix.
  # Its prefix and songs go under the data directory rather than ~/.osu.
  home.packages = [
    (inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-stable.override {
      location = "${config.xdg.dataHome}/osu-stable";
      useGameMode = false;
    })
  ];
}
