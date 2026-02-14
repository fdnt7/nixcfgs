{ pkgs, ... }:
{
  home.packages =
    let
      inherit (pkgs) musescore muse-sounds-manager;
    in
    [
      musescore
      muse-sounds-manager
    ];
}
