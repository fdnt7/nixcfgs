{ pkgs, ... }:
{
  wayland.windowManager.hyprland.settings.bindrt =
    let
      showleds = import ./scripts/showleds.nix { inherit pkgs; };
    in
    [
      "MOD2, Num_Lock , exec, uwsm-app -- ${showleds} n"
      #"CAPS, Caps_Lock, exec, uwsm-app -- ${showleds} c" # doesn't work due to caps:escape_shifted_capslock
      #"CAPS SHIFT, Shift_L, exec, uwsm-app -- ${showleds} c" # only seems to work sometimes
    ];
}
