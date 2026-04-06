{ lib, pkgs, ... }:
{
  home.packages = lib.mkIf false [ pkgs.cisco-packet-tracer_9 ];
}
