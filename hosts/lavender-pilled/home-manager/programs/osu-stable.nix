{
  config,
  inputs,
  pkgs,
  ...
}:
{
  home.packages = [
    (inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-stable.override {
      location = "${config.xdg.dataHome}/osu-stable";
    })
  ];
}
