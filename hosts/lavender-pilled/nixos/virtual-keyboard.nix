{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.kdePackages.plasma-keyboard ];
}
