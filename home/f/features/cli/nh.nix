{ config, ... }:
{
  # `nh os switch` builds as the user, shows what changes, and asks for
  # elevation only to activate.
  programs.nh = {
    enable = true;
    flake = "${config.xdg.configHome}/nixos";
  };
}
