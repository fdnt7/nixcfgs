{ pkgs, ... }:
{
  # Notation editor, and the manager that downloads its Muse Sounds
  # instrument libraries. There is no module for either.
  home.packages = [
    pkgs.musescore
    pkgs.muse-sounds-manager
  ];
}
