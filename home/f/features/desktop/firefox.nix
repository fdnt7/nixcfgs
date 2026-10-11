{ config, ... }:
{
  programs.firefox = {
    enable = true;
    # Where Firefox keeps its profiles when ~/.mozilla does not exist. Home
    # Manager only defaults to it from state version 26.11, and its older
    # default would create ~/.mozilla and hide the existing profile.
    configPath = "${config.xdg.configHome}/mozilla/firefox";
  };
}
