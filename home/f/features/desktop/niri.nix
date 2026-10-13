{ pkgs, ... }:
{
  # The config is complete in itself and does not include niri's default one,
  # whose binds could be overridden but never removed.
  wayland.windowManager.niri = {
    enable = true;
    enableDefaultConfig = false;
    extraConfig = builtins.readFile ./niri.kdl;
  };

  # What the binds call for the media and brightness keys.
  home.packages = [
    pkgs.brightnessctl
    pkgs.playerctl
  ];
}
