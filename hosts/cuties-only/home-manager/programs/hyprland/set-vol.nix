{ pkgs, ... }:
{
  wayland.windowManager.hyprland.settings.binde =
    let
      set-vol = import ./scripts/set-vol.nix { inherit pkgs; };
    in
    [
      ", XF86AudioLowerVolume, exec, ${set-vol} sink d"
      ", XF86AudioRaiseVolume, exec, ${set-vol} sink u"
    ];
}
