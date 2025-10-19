{ pkgs, ... }:
{
  home.packages = [ pkgs.grimblast ];

  wayland.windowManager.hyprland.settings.bind = [
    "$mod Shift_L, s    , exec, uwsm-app -- grimblast --notify copysave area" # fn+f6
    "            , Print, exec, uwsm-app -- grimblast --notify copysave screen"
    "$mod        , Print, exec, uwsm-app -- grimblast --notify copysave active"
  ];
}
