{ inputs, pkgs, ... }:
{
  # From nix-gaming, which tracks releases closely; its binary cache is set
  # up in ../../../../hosts/common/optional/gaming.nix. There is no module.
  home.packages = [
    inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-lazer-bin
  ];

  # Discord's "join" and "spectate" links for the game. The handler is
  # an entry osu! writes for itself each time it starts.
  xdg.mimeApps.defaultApplications."x-scheme-handler/discord-1216669957799018608" =
    "discord-1216669957799018608.desktop";
}
