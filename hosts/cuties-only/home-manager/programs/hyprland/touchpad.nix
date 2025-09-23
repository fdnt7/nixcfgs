{
  inputs,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    input.touchpad.natural_scroll = true;
    "$LAPTOP_TOUCHPAD_ENABLED" = false;
    device = {
      name = "asuf1204:00-2808:0202-touchpad";
      enabled = "$LAPTOP_TOUCHPAD_ENABLED";
    };
    bind = let
      toggle-touchpad = import ./scripts/toggle-touchpad.nix {inherit inputs pkgs;};
    in [
      ", XF86TouchPadToggle, exec, uwsm-app -- ${toggle-touchpad}" #fn+f10
    ];
  };
}
