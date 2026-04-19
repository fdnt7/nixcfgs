{ lib, pkgs, ... }:
{
  home.packages = lib.mkIf false [ pkgs.brave ];
}
