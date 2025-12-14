{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./no-gaps-when-only.nix
    ./set-vol.nix
    ./showleds.nix
    ./toggle-mute.nix
    ./touchpad.nix
  ];

  nix.settings = {
    extra-substituters = [ "https://hyprland.cachix.org" ];
    extra-trusted-substituters = [ "https://hyprland.cachix.org" ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.enable = false;
    plugins = with inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}; [
      hyprscrolling
    ];
    settings = {
      monitor = [
        "eDP-2,preferred,auto,1"
        ",preferred,auto,1,mirror,eDP-2"
      ];

      input = {
        kb_layout = "us,th";
        kb_options = "caps:escape,grp:win_space_toggle"; # allows zed's shift+end keybind
        numlock_by_default = true;
        repeat_rate = 40;
        repeat_delay = 200;
        follow_mouse = 1;
        sensitivity = 0;
        accel_profile = "flat";
      };

      general = {
        gaps_in = 0;
        gaps_out = 0;
        border_size = 1;
        layout = "scrolling";
        allow_tearing = true;
      };

      decoration = {
        rounding = 0;
        blur = {
          enabled = true;
          size = 8;
          passes = 3;
          special = false;
        };

        shadow.enabled = false;

        dim_special = 0.5;
      };

      animations = {
        enabled = true;
        animation = [
          "windowsIn, 1, 3, default, popin 50%"
          "windowsOut, 1, 4, default, popin 75%"
          "windowsMove, 1, 3, default"
          "border, 1, 10, default"
          "borderangle, 1, 7.5, default"
          "fade, 1, 7, default"
          "workspaces, 1, 3, default, slidefadevert 10%"
          "specialWorkspace, 1, 4, default, slidefadevert 5%"
          "layers, 1, 2.5, default, fade"
          "fadeLayers, 1, 2.5, default"
        ];
      };

      windowrulev2 = [
        # Ignore maximize requests from apps. You'll probably like this.
        "suppressevent maximize, class:.*"

        # Fix some dragging issues with XWayland
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

        "pin, class:^(org.gnupg.pinentry-qt)$"

        # for whatever reasons, both `Xdg-...` and `xdg-` exists ...
        "pin, class:^(Xdg-desktop-portal-gtk)$"
        "pin, class:^(xdg-desktop-portal-gtk)$"

        "workspace 1, class:^(firefox)$"
        "workspace 1, class:^(Vivaldi-stable)$"
        "workspace 3, class:^(Code)$"
        "workspace 3, class:^(dev.zed.Zed)$"
        "workspace 5, class:^(Gimp)$"
        "workspace 5, class:^(krita)$"
        "workspace 6, class:^(MuseScore4)$"
        "workspace 6, class:^(Muse Sounds Manager)$"
        "workspace 8, class:^(steam_app_)(\\d+)$"
        "workspace 8, class:^(osu!)$"

        "float, class:^(oculante)$"
        "float, class:^(pix)$"
        "float, class:^(swayimg_.*)$"
        "float, class:^(mscore4portable)$"
        "float, class:^(Muse Sounds Manager)$"
        "float, class:^(pavucontrol)$"
        "float, class:^(nm-connection-editor)$"

        # this doesn't automatically float for whatever reasons but
        # the capitalised `Xdg-...` does.
        "float, class:^(xdg-desktop-portal-gtk)$"

        # ... ditto
        "noblur, class:^(xdg-desktop-portal-gtk)$"
        "noblur, class:^(Xdg-desktop-portal-gtk)$"

        "noblur, class:^(MuseScore4)$"
        "noblur, class:^()$, title:^()$"
        "noblur, class:^(line.exe)$"

        "noshadow, class:^(line.exe)$"

        # ... ditto
        "noborder, class:^(xdg-desktop-portal-gtk)$"
        "noborder, class:^(Xdg-desktop-portal-gtk)$"

        "workspace special:minimised, class:^(steam)$"

        "workspace special:chat, class:^(vesktop)$"
        "workspace special:chat, class:^(discord)$"
        "workspace special:chat, class:^(de.shorsh.discord-screenaudio)$"

        "workspace special:music, class:^(pavucontrol)$"

        "workspace special:scratch, class:^(Alacritty)$"
        "workspace special:scratch, class:^(org.wezfurlong.wezterm)$"
        "workspace special:scratch, class:^(foot)$"
        "workspace special:scratch, class:^(kitty)$"
      ];

      "$mod" = "SUPER";
      "$sws_1" = "grave";
      "$sws_2" = "minus";
      "$sws_3" = "equal";
      "$sws_4" = "BackSpace";

      "$term" = "foot";
      "$term_alt" = "foot";

      binde = [
        "$mod CTRL, h, layoutmsg, colresize -conf"
        "$mod CTRL, j, layoutmsg, colresize -0.2"
        "$mod CTRL, k, layoutmsg, colresize +0.2"
        "$mod CTRL, l, layoutmsg, colresize +conf"

        "$mod, Tab, layoutmsg, move +col"
        "$mod SHIFT, Tab, layoutmsg, move -col"
      ];

      bind = [
        #fn+f2 o
        #fn+f3 o
        "            , XF86Launch4          , exec, uwsm-app --" # fn+f4
        #fn+f5 -

        "$mod        , p                    , exec, uwsm-app --" # fn+f9

        #fn+f11 o
        #fn+f12 -

        "$mod SHIFT, q, exec, uwsm-app -- qr"

        "$mod, w, killactive"
        "$mod, e, swapnext"
        "$mod SHIFT, e, swapnext, prev"
        "$mod, r, exec, uwsm-app -- rofi -show run -show-icons"
        "$mod, t, pseudo"
        "$mod           , y, cyclenext, tiled"
        "$mod SHIFT     , y, cyclenext, prev tiled"
        "$mod CTRL      , y, cyclenext, floating"
        "$mod CTRL SHIFT, y, cyclenext, prev floating"

        "$mod, u, layoutmsg, promote"

        "$mod, i, pin"
        "$mod, bracketleft , alterzorder, bottom"
        "$mod, bracketright, alterzorder, top"

        "$mod, a, exec, uwsm-app -- rofi -show drun -show-icons"
        "$mod, s, togglesplit"
        "$mod, f, togglefloating"
        "$mod SHIFT, f, fullscreen"

        "$mod, h, layoutmsg, focus l"
        "$mod, j, layoutmsg, focus d"
        "$mod, k, layoutmsg, focus u"
        "$mod, l, layoutmsg, focus r"

        "$mod SHIFT, h, layoutmsg, movewindowto l"
        "$mod SHIFT, j, layoutmsg, movewindowto d"
        "$mod SHIFT, k, layoutmsg, movewindowto u"
        "$mod SHIFT, l, layoutmsg, movewindowto r"

        "$mod CTRL SHIFT, h, layoutmsg, fit tobeg"
        "$mod CTRL SHIFT, l, layoutmsg, fit toend"

        "$mod, semicolon, exec, uwsm-app -- lock"
        "$mod CTRL, s, exec, uwsm-app -- swww-next"

        "$mod, c, centerwindow"

        "$mod ALT, f, exec, uwsm-app -- dolphin"
        "$mod ALT, m, exec, uwsm-app -- mscore"
        "$mod ALT, z, exec, uwsm-app -- zed"
        "$mod ALT, c, exec, uwsm-app -- code"
        "$mod ALT, v, exec, uwsm-app -- mullvad-gui"
        "$mod ALT, x, exec, uwsm-app -- xournalpp"

        "$mod, Return , exec, uwsm-app -- $term"
        "$mod, Shift_R, exec, uwsm-app -- $term_alt"

        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        "$mod      , $sws_1, togglespecialworkspace, scratch"
        "$mod CTRL , $sws_1, movetoworkspace       , special:scratch"
        "$mod SHIFT, $sws_1, movetoworkspacesilent, special:scratch"
        "$mod      , $sws_2, togglespecialworkspace, minimised"
        "$mod CTRL , $sws_2, movetoworkspace       , special:minimised"
        "$mod SHIFT, $sws_2, movetoworkspacesilent, special:minimised"
        "$mod      , $sws_3, togglespecialworkspace, music"
        "$mod CTRL , $sws_3, movetoworkspace       , special:music"
        "$mod SHIFT, $sws_3, movetoworkspacesilent, special:music"
        "$mod      , $sws_4, togglespecialworkspace, chat"
        "$mod CTRL , $sws_4, movetoworkspace       , special:chat"
        "$mod SHIFT, $sws_4, movetoworkspacesilent, special:chat"

        "$mod, v, exec, uwsm-app -- vpn"

        "$mod, o, exec, uwsm-app -- uwsm-app -- xdg-open $(wl-paste)"

        #", SUPER_L, exec, ${bar} 1"
      ]
      ++ (builtins.concatLists (
        builtins.genList (
          x:
          let
            ws =
              let
                c = (x + 1) / 10;
              in
              builtins.toString (x + 1 - (c * 10));
          in
          [
            "$mod      , ${ws}, workspace            , ${toString (x + 1)}"
            "$mod CTRL , ${ws}, movetoworkspace      , ${toString (x + 1)}"
            "$mod SHIFT, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
          ]
        ) 10
      ));

      bindm = [
        "$mod, mouse:272, movewindow"

        "$mod, mouse:273, resizewindow"
      ];

      bindrt = [
        #"$mod, SUPER_L, exec, ${bar0}"
      ];

      plugin = {
        hyprscrolling = {
          fullscreen_on_one_column = true;
          focus_fit_method = 1;
        };
      };
    };

    #extraConfig = ''
    #  bind=$mod ALT, d, submap, discord
    #  submap=discord
    #    bind=, v     , exec  , ${bar0}; uwsm-app -- vesktop
    #    bind=, v     , submap, reset
    #    bind=, d     , exec  , ${bar0}; uwsm-app -- discord
    #    bind=, d     , submap, reset
    #    bind=, s     , exec  , ${bar0}; uwsm-app -- discord-screenaudio
    #    bind=, s     , submap, reset
    #    bind=, c     , exec  , ${bar0}; uwsm-app -- discordcanary
    #    bind=, c     , submap, reset
    #    bind=, escape, exec  , ${bar0}
    #    bind=, escape, submap, reset
    #  submap=reset
    #
    #  bind=$mod ALT, b, submap, browser
    #  submap=browser
    #    bind=, b     , exec  , ${bar0}; uwsm-app -- brave;
    #    bind=, b     , submap, reset
    #    bind=, z     , exec  , ${bar0}; uwsm-app -- zen
    #    bind=, z     , submap, reset
    #    bind=, v     , exec  , ${bar0}; uwsm-app -- vivaldi
    #    bind=, v     , submap, reset
    #    bind=, escape, exec  , ${bar0}
    #    bind=, escape, submap, reset
    #  submap=reset
    #
    #  bind=$mod, q, submap, power
    #  submap=power
    #    bind=, q     , exit
    #    bind=, q     , submap, reset
    #    bind=, s     , exec  , poweroff
    #    bind=, s     , submap, reset
    #    bind=, r     , exec  , reboot
    #    bind=, r     , submap, reset
    #    bind=, escape, exec  , ${bar0}
    #    bind=, escape, submap, reset
    #  submap=reset
    #
    #  bind=$mod, d, submap, develop
    #  submap=develop
    #    bind=, l     , exec  , ${bar0}; uwsm-app -- nix-develop-lyra
    #    bind=, l     , submap, reset
    #    bind=, escape, exec  , ${bar0}
    #    bind=, escape, submap, reset
    #  submap=reset
    #'';
  };
}
