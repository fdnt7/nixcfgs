{pkgs, ...}: {
  wayland.windowManager.hyprland.settings.bind = let
    toggle-mute = import ./scripts/toggle-mute.nix {inherit pkgs;};
  in [
    ", XF86AudioMicMute, exec, uwsm-app -- ${toggle-mute} src"
    ", XF86AudioMute   , exec, uwsm-app -- ${toggle-mute} sink" #fn+f1
  ];
}
